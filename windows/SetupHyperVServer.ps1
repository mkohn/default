#checks to see if this is an admin account
if ([Environment]::UserName.StartsWith("&")) {
	Write-Output "Congrats you are running this as your admin account. Go get yourself a beer on Francis!"
} 
else {
	Write-Error "Please run the tool with your elevated account"; 
	exit
}

if (test-path "C:\Program Files\EqualLogic\bin\EqlMpioPSTools.dll"){
	write-output "Dell management installed"
}
else {
	\\ukloncm001\Software_Deployments\Dell\Equalogic\HIT\4.7.1\Setup64.exe /S /v/qn
	sleep 60000
    
}
#sets some high level varibles that are needed
$Server = (Get-Childitem env:computername).value.tostring()
$Site = $Server.Substring(0,$Server.Length-5)
switch ($Site){
	"UKLON" {
		$First_Octets = "10.62"
        	$FirstIP = [int]30
	}
	"UKL2" {
		$First_Octets = "10.69"
        	$FirstIP = [int]10
	}
	"IELMK" {
		$First_Octets = "10.20"
        	$FirstIP = [int]10
	}
	"USSF" {  
		$First_Octets = "10.30"
        	$FirstIP = [int]30
	}
	"USNYC" {
		$First_Octets = "10.40"
        	$FirstIP = [int]10
	}
	"CHGVA" {
		$First_Octets = "10.50"
        	$FirstIP = [int]10
	}
	"IELIM" {
		$First_Octets = "10.60"
       		$FirstIP = [int]10
	}
	"TRIST" {
		$First_Octets = "10.70"
        	$FirstIP = [int]10
	}
    "UKLCY
	default {
        $First_Octets = "10.80"
        	$FirstIP = [int]10
	}
		Write-Error "There is a problem I can't figure out what site you are at"
		exit
	}
}

#Current Computer Specific configs
$SANIP = [int]200

#setting some variables to use for IP address below
$Internal_IP = $First_Octets + ".10."
$Cluster_IP = $First_Octets + ".110."
$Live_IP = $First_Octets + ".120."
$iSCSI_IP = $First_Octets + ".100."


#install hyperv and failover
if (!(get-WindowsFeature -name Hyper-V).Installed){
	Install-WindowsFeature Hyper-V, Multipath-IO, Failover-Clustering -IncludeAllSubFeature -IncludeManagementTools 
	restart-computer
	}
else {
	Install-WindowsFeature Multipath-IO, Failover-Clustering -verbose -IncludeManagementTools -IncludeAllSubFeature
}

#Assigning IP Addresses
$LastOctet=[String]($Server.Substring($Server.length-2))

if (([int]$LastOctet -le 10) -and ([int]$LastOctet -gt 50)) {
	write-output "I don't like what I come up with for the last IP of the server"
	exit  	
} 


if ((Get-NetAdapter| where Name -like *Cluster* ).count -le 2) {
	Write-error "You forgot to rename the nic cards. Please go back in time drink one less beer and try again"
	exit
}

#Create TM Cluster
new-netLBFOTeam -Name "TM Cluster" -TeamMembers *Cluster* -LoadBalancingAlgorithm HyperVPort -TeamingMode LACP -Verbose

# added Prod and Cluster and LM Nics
New-VMSwitch "VMSwitch" -MinimumBandwidthMode weight -NetAdapterName "TM Cluster" -AllowManagement $false -Verbose
Set-VMSwitch "VMSwitch" -DefaultFlowMinimumBandwidthWeight 50
Add-VMNetworkAdapter -ManagementOS -Name "Live Migration" -SwitchName "VMSwitch" -Verbose
Set-VMNetworkAdapter -ManagementOS -Name "Live Migration" -MinimumBandwidthWeight 20
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Live Migration" -Access -VlanID 120
Add-VMNetworkAdapter -ManagementOS -Name "Cluster" -SwitchName "VMSwitch" -Verbose
Set-VMNetworkAdapter -ManagementOS -Name "Cluster" -MinimumBandwidthWeight 10
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Cluster" -Access -VlanID 110
Add-VMNetworkAdapter -ManagementOS -Name "Production" -SwitchName "VMSwitch" -Verbose
Set-VMNetworkAdapter -ManagementOS -Name "Production" -MinimumBandwidthWeight 10
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Production" -Access -VlanID 10


New-NetIPAddress –InterfaceAlias “vEthernet (Production)” -AddressFamily IPv4 -IPAddress  ($Internal_IP + $LastOctet) –PrefixLength 24 -DefaultGateway ($Internal_IP + "254")
New-NetIPAddress –InterfaceAlias “vEthernet (Cluster)” –AddressFamily IPv4 -IPAddress  ($Cluster_IP + $LastOctet) –PrefixLength 24
New-NetIPAddress –InterfaceAlias “vEthernet (Live Migration)” -AddressFamily IPv4 -IPAddress ($Live_IP + $LastOctet) –PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias “vEthernet (Production)” -ServerAddresses ($Internal_IP + "1"), 10.62.72.1

#set some temp variables that are used for Setting iSCSI IP
$x=0
$IP = ""

#creating and setting 
foreach ($NIC in (Get-NetAdapter | where name -like *iSCSI* | sort name )){
    $x++
    if ($LastOctet.StartsWith(1)){
        $IP = [string]::concat($iSCSI_IP, [String]($Server.Substring($Server.length-1)), [String]$x)
    }
    else {
     #$IP = [string]::concat($iSCSI_IP, "1", [String]($Server.Substring($Server.length-1)), [String]$x)
	 $IP = [string]::concat($iSCSI_IP, [String]($Server.Substring($Server.length-1)), [String]$x)
    }
	#$ip
	New-NetIPAddress -InterfaceAlias $Nic.name -IPAddress $IP -PrefixLength 22
}


#disable registerDNS
Get-DnsClient | ? {$_.InterfaceAlias -like "iSCSI*"} | Set-DnsClient -RegisterThisConnectionsAddress:$false  
Get-DnsClient | ? {$_.InterfaceAlias -like "*Cluster*"} | Set-DnsClient -RegisterThisConnectionsAddress:$false  
Get-DnsClient | ? {$_.InterfaceAlias -like "*Live*"} | Set-DnsClient -RegisterThisConnectionsAddress:$false  
Get-DnsClient | ? {$_.InterfaceAlias -like "*VMs*"} | Set-DnsClient -RegisterThisConnectionsAddress:$false

#disable netbios
$iSCSI_Nics = (Get-NetAdapter | Where-Object name -like *iSCSI).InterfaceDescription
foreach ($nic in $iSCSI_Nics) {
	$netbios=(gwmi -query "select * from win32_networkadapter where name= '$nic'").deviceid
	([wmi]"\\.\root\cimv2:Win32_NetworkAdapterConfiguration.Index=$netbios").SetTcpipNetbios(2)
}


#setup Nic Cards
Get-NetAdapter | Where-Object name -like NIC* | set-NetAdapterAdvancedProperty -RegistryKeyword “*JumboPacket” -Registryvalue 9000
Get-NetAdapter | Where-Object name -like *iSCSI* | Disable-NetAdapterBinding -AllBindings  
Get-NetAdapter | Where-Object name -like *iSCSI* | Enable-NetAdapterBinding -ComponentID ms_tcpip


#disable LMhost Lookup
$nic = [wmiclass]'Win32_NetworkAdapterConfiguration'
$nic.enablewins($false,$false)

#Setup Dell tools
import-module "C:\Program Files\EqualLogic\bin\EqlMpioPSTools.dll"

Set-EqlMpioConfiguration -MaxSessionsPerVolumeSlice 4 -MaxSessionsPerEntireVolume 8 -MinAdaptorSpeed 1000 -DefaultLoadBalancing 4
Set-EqlMpioRule -Default -Exclude
Set-EqlMpioRule -Netmask 255.255.252.0 -Subnet ($iSCSI_IP + "0")
Set-EqlMpioRule -Netmask 255.255.255.0 -Subnet ($Internal_IP + "0")  -Exclude
Set-EqlMpioRule -Netmask 255.255.255.0 -Subnet ($Live_IP + "0")  -Exclude
Set-EqlMpioRule -Netmask 255.255.255.0 -Subnet ($Cluster_IP + "0") -Exclude

#adding iSCSI Targets
New-IscsiTargetPortal -TargetPortalAddress ($iSCSI_IP + $SANIP)
Update-IscsiTarget
$iscsiTargets = Get-IscsiTarget | where-object  IsConnected -Like Fal* | where nodeaddress -NotLike *control
foreach ($target in $iscsiTargets){
	Connect-IscsiTarget -NodeAddress $target.nodeaddress -IsMultipathEnabled $true -IsPersistent $true
}

#configuring hyper-v
mkdir "C:\Switchme"
SET-VMHOST –computername $Server  –virtualharddiskpath 'C:\Switchme'
SET-VMHOST –computername $Server  –virtualmachinepath 'C:\Switchme' -MaximumVirtualMachineMigrations 4 -MaximumStorageMigrations 4


$ClusterName = [string]::concat($Server.Substring(0,$Server.length-5),"CLS","0", $LastOctet[0], "0")
#if cluster exists, adds to cluster
try {
    Test-Connection $Clustername
	} 
Catch {
    Write-warning "Cluster does not exist yet therefore I can't add it to the cluster!" 
	exit
    }

$AddtoCluster = Read-Host 'Would you like me to do your bidding and add this machine to the cluster? (y/n)'
While (!$AddtoCluster.Equals('y') -and !$AddtoCluster.Equals('n')){
	$AddtoCluster = Read-Host 'COMMON!!! y or n only; Would you like me to do your bidding and add this machine to the cluster? (y/n)'
}

if ($AddtoCluster -eq "y"){
	add-clusternode -Name  $Server -Cluster $ClusterName
}
else{
	write-Output "Well I did what you told and didn't add it to the cluster!"
}  

Write-Output "I have done your job for you! Have a nice day!"

Write-Output "MAKE SURE YOU CHANGE THE DEFAULT HYPER-V PATH"

# SIG # Begin signature block
# MIIMQwYJKoZIhvcNAQcCoIIMNDCCDDACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDsRl0p669T4Xvkdh12TB22mU
# CUmgggm7MIIEaTCCA1GgAwIBAgIKKiEQkAAAAAAuJzANBgkqhkiG9w0BAQUFADAS
# MRAwDgYDVQQDEwd2aWFnb2dvMB4XDTExMDkxMjE0MzQzOVoXDTE2MDMwMTA5MjUz
# MlowQzEUMBIGCgmSJomT8ixkARkWBGNvcnAxFzAVBgoJkiaJk/IsZAEZFgd2aWFn
# b2dvMRIwEAYDVQQDEwl2aWFnb2dvTjIwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJ
# AoGBAL5lWMYGnZWknKzwX45tHLYLdNQQRkHlsYHoWWuCDclGA2pwPVL6CsEiecxh
# Evz2r8B0VzWj9U+Zk/XyIpRiO2VG/Xh915il8uNzOgeY7T9J5PFMGbrJIh7VpVot
# 4fg0EqdA1GS3TCcBpb+9HOtK6GyOovvpWRGmw4TK2sP9ns5ZAgMBAAGjggISMIIC
# DjASBgkrBgEEAYI3FQEEBQIDCgAKMCMGCSsGAQQBgjcVAgQWBBS6cjEYQROGkv/Z
# zbWH7A8lWvWxqjAdBgNVHQ4EFgQUquFvZRqtuZTFS/oc7e8gIc42AXwwGQYJKwYB
# BAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMB
# Af8wHwYDVR0jBBgwFoAUDHefbrszfUReIWHRxuJHIOiPcQwwgcYGA1UdHwSBvjCB
# uzCBuKCBtaCBsoaBr2xkYXA6Ly8vQ049dmlhZ29nbyxDTj1DZXJ0LTAxLENOPUNE
# UCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25m
# aWd1cmF0aW9uLERDPXZpYWdvZ28sREM9Y29ycD9jZXJ0aWZpY2F0ZVJldm9jYXRp
# b25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgZAG
# CCsGAQUFBwEBBIGDMIGAMH4GCCsGAQUFBzAChnJsZGFwOi8vL0NOPXZpYWdvZ28s
# Q049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENO
# PUNvbmZpZ3VyYXRpb24sREM9dmlhZ29nbyxEQz1jb3JwP2NBQ2VydGlmaWNhdGUw
# DQYJKoZIhvcNAQEFBQADggEBACCCFRGtp+UUx8xDeFh/orx5L2XJ0ki2da4GcibD
# WuIbArkS+sNMwzC3Rvi5ClwkgTTHJAU3cdcrkXgwlWoc15tYawC3qiazIbWw/of+
# fApAkBkwg/erXcR5SCBJ2J9RngwH833rDaOaXtfIm3SsGtM9WkKzwObox6fJLQRp
# nbcsRG/33GB9Uj1wJSCbQgY7drhlLB9AYVUcL0dyjro6b2HO7bjzdnxuCUTPAwSW
# HG5lTaHpXUZiV3utNAied0/BXN2RdUfz3/nXO8NMkBo1RWnN2Q1izJDr7R6tIoud
# sxams8VMnwTFFLaAknk+cxpcJr3NKhnxY93mLtfNo70wtP0wggVKMIIEs6ADAgEC
# AgpOMxM9AAoACGTSMA0GCSqGSIb3DQEBBQUAMEMxFDASBgoJkiaJk/IsZAEZFgRj
# b3JwMRcwFQYKCZImiZPyLGQBGRYHdmlhZ29nbzESMBAGA1UEAxMJdmlhZ29nb04y
# MB4XDTE0MDIyNzE1MjcyNFoXDTE1MDIyNzE1MjcyNFowbTEUMBIGCgmSJomT8ixk
# ARkWBGNvcnAxFzAVBgoJkiaJk/IsZAEZFgd2aWFnb2dvMRAwDgYDVQQLEwdWSUFH
# T0dPMQswCQYDVQQLEwJJVDEdMBsGA1UEAxMUTWF0dGhldyBLb2huIChBZG1pbikw
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxsr+fSPockkfT/A56wTQU
# 8efL6WSvy76YsBnHO4r09QJNFl1ULG4Voiv0PFhsTNybwN0x3G9Brb+gA82akgwU
# JS4t1RdE3OQqznWDD4zObX0sfIPlxgt7QB1aFBT334QasT7hVehgRr+lyNr7IaGg
# 0I/gdA1mooQkrNLVVpN9/Otub0rfSZzUiwWemYxF+8VKLZTqnwu8LcSfos/E4VAU
# kcd3Dm/z8K4+Ypm/Rqn8+VU9gZ7Hd7NTxEkmR+sM9tzBh95HqIwt6O+eVXdfCCsA
# 5giiG6JkcSlMqPd2nOk1jAGIeWyYDL3B/PrljFsBa3QB8OoJROHvmrG21JxIKhs1
# AgMBAAGjggKVMIICkTAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBpAGcAbgBp
# AG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0O
# BBYEFINrOVEdqOa/5mcmIuFBj1coRz73MB8GA1UdIwQYMBaAFKrhb2UarbmUxUv6
# HO3vICHONgF8MIIBCwYDVR0fBIIBAjCB/zCB/KCB+aCB9oaBt2xkYXA6Ly8vQ049
# dmlhZ29nb04yKDEwKSxDTj1OZXR3b3JrLTIsQ049Q0RQLENOPVB1YmxpYyUyMEtl
# eSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9dmlh
# Z29nbyxEQz1jb3JwP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmpl
# Y3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludIY6aHR0cDovL25ldHdvcmstMi52
# aWFnb2dvLmNvcnAvQ2VydEVucm9sbC92aWFnb2dvTjIoMTApLmNybDCBvAYIKwYB
# BQUHAQEEga8wgawwgakGCCsGAQUFBzAChoGcbGRhcDovLy9DTj12aWFnb2dvTjIs
# Q049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENO
# PUNvbmZpZ3VyYXRpb24sREM9dmlhZ29nbyxEQz1jb3JwP2NBQ2VydGlmaWNhdGU/
# YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MDUGA1UdEQQu
# MCygKgYKKwYBBAGCNxQCA6AcDBomTWF0dGhldy5Lb2huQHZpYWdvZ28uY29ycDAN
# BgkqhkiG9w0BAQUFAAOBgQCABTYTEPD673CKOxYgbBEtZOAMnrSoQ8PSrb6Uzoix
# JAypame7r5VcyC7nA7aArTRRuILvec6W2izO2RVDbuFNsmpOVcwLbacfQy+qEulb
# zvdFQqcOW/m9wPBdL3QqlLbIfY/Mexg30Wg9vmEqTN39AGN5/0VXEwDkMeqiReZU
# eTGCAfIwggHuAgEBMFEwQzEUMBIGCgmSJomT8ixkARkWBGNvcnAxFzAVBgoJkiaJ
# k/IsZAEZFgd2aWFnb2dvMRIwEAYDVQQDEwl2aWFnb2dvTjICCk4zEz0ACgAIZNIw
# CQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# IwYJKoZIhvcNAQkEMRYEFIipxi5ay75u1LABx+DnlQRFO95AMA0GCSqGSIb3DQEB
# AQUABIIBADApI+VAp4Cvu5MzERK1KvToRqmqpI4Vkcs0sXNdZA2OhKsE/Ooblvsy
# prBb1rMtdVWDU185hLhQt1dKr77BrZQP1nAsGVNaovYOts1isLPu3zNgNDR7vhnf
# hf76miTUMzNn1T3znhHLmTe6Ige0YhoQPY/oJif8oKpA25sh3OK6FvpWAMB5zbpM
# Oia8JJZlW2C3Ft3Qwknhv1yMZC9EiQnMIh74sW1GfFzoPJ+DrCnEgunfoi/yRAsu
# J2M2lQS9gvo0/Stmu79X6hYp7zZ+hXXe3w3r9BSUcgQC5Th8LsYwEsE7N7GVv0Wt
# 4n8QWm32Ejv7Nim3QaLxaAOrkNvgYtM=
# SIG # End signature block
