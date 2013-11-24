#THINGS to set
$ExportPath="C:\Temp\groups.csv"
$searchroot="" 


#Don't touch below

#import Quest Module
Add-PSSnapin Quest.ActiveRoles.ADManagement
 if (test-path $location){
	remove-item -path $ExportPath -force
}
#gets users
$listofgroups = Get-QADGroup -SearchRoot $searchroot | select -property name,GroupType,Description,Notes 

#for each user it gets the groups
foreach ($line in $listofgroups){
	$name=$line.Name
	#Get-QADGroupMember  $name -Indirect | Select-Object SamAccountName  | Out-File -append $path
	 
	$members =(Get-QADGroupMember $Name -Type user -SizeLimit 0 | Foreach-Object {$_.Name}) -join ';' 
	$name + ";" + $line.Description + ";" +  $line.GroupType + ";" + $members | out-file $ExportPath -Append
}


# SIG # Begin signature block
# MIIHTgYJKoZIhvcNAQcCoIIHPzCCBzsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVqBMGNDgWrCZg1aw0NmI9sGn
# dNqgggVAMIIFPDCCBCSgAwIBAgIKRxvVuwABAAABtjANBgkqhkiG9w0BAQUFADBK
# MRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFTATBgoJkiaJk/IsZAEZFgVITUNBUDEa
# MBgGA1UEAxMRSE1DQVAtSE1DRENWSVItQ0EwHhcNMTMxMDMwMjAxMDQzWhcNMTQx
# MDMwMjAxMDQzWjCBlTEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRUwEwYKCZImiZPy
# LGQBGRYFSE1DQVAxEjAQBgNVBAsMCUhNQ19Vc2VyczEaMBgGA1UECwwRU3RhbmRh
# cmRfQWNjb3VudHMxCzAJBgNVBAsTAklUMREwDwYDVQQLEwhpZSB0ZXN0czEVMBMG
# A1UEAxMMTWF0dGhldyBLb2huMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCt
# FFP4CuOeuT8KQQAszgY+1w3fOHASU2+HKG+jEmb0m//VRIm+AmPuaExfbUjRrmxz
# GPiCzq92LUmiyLVFJIjOjDf3Q/SkReMCs9DOI6iyB3BYE2PdpqdGtIxUxohEgZJs
# MrxmGMf20RKQH5C+CxTxdq6C6t0hvhJ7XnOUX+I7/QIDAQABo4ICWjCCAlYwDgYD
# VR0PAQH/BAQDAgeAMCUGCSsGAQQBgjcUAgQYHhYAQwBvAGQAZQBTAGkAZwBuAGkA
# bgBnMB0GA1UdDgQWBBQTLXJJpa0/m4xTyTnbcWgsDj2TETAfBgNVHSMEGDAWgBR+
# tkIkaYWuEAVouTO8dbNL2y7qqTCB0wYDVR0fBIHLMIHIMIHFoIHCoIG/hoG8bGRh
# cDovLy9DTj1ITUNBUC1ITUNEQ1ZJUi1DQSgxKSxDTj1ITUNEQ1ZJUixDTj1DRFAs
# Q049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmln
# dXJhdGlvbixEQz1ITUNBUCxEQz1sb2NhbD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25M
# aXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgcMGCCsG
# AQUFBwEBBIG2MIGzMIGwBggrBgEFBQcwAoaBo2xkYXA6Ly8vQ049SE1DQVAtSE1D
# RENWSVItQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNl
# cnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9SE1DQVAsREM9bG9jYWw/Y0FDZXJ0
# aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwLAYDVR0RBCUwI6AhBgorBgEEAYI3FAIDoBMM
# EW1rb2huQEhNQ0FQLmxvY2FsMA0GCSqGSIb3DQEBBQUAA4IBAQCfLIjnGuxOO8cD
# ZzWYqwoF7f9CZ/lAxxQr6IHfAa7oMLLfOq0Bv0sFaJWC/+qPLCRf7n5NalC5erb4
# OZAP3CqRizPugq5UebNmDsUElimmV5yDuLT7liqzdgCjTQzDfZ3fjJXmFBJJ/vbN
# 1GelyhLTsCNd5G25WYToY8triGgjxqs4h4Yyko44OHmV+4xkOP7DcDhV0jvm0k9B
# ZNXV+j+g4zRyqzvGUiu9PWQzbhYdZOuFZNyAszIkUiVCFFSVr+zjUFiDEt+Jpe9l
# 9dXTXnK8FBf2FQ5dtbfwEcZ4UtWtJzhiQt6i2q8kkB5avzcvUUHr6JvIrHNb2Qrh
# r2Yyv0XMMYIBeDCCAXQCAQEwWDBKMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFTAT
# BgoJkiaJk/IsZAEZFgVITUNBUDEaMBgGA1UEAxMRSE1DQVAtSE1DRENWSVItQ0EC
# Ckcb1bsAAQAAAbYwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFJH9J6k2nSO5rNnZe14uuGqLj3ox
# MA0GCSqGSIb3DQEBAQUABIGANAbS3Wmm3g/gdB61c5l0xSQJ0XCs1H8dQKzI/spa
# 3f7/ZP91BeMErIzQ9Fj0SlZ4ptD93gr1yj+bJQVAeVvjpE4L1OKZqyYzUobCGN0r
# C/BKGd4mFttAHGTBIjuXrNHNcLNrQmbdYKhotkwuWmgDmW/WoDVpxPbi104U8K/o
# 1XM=
# SIG # End signature block
