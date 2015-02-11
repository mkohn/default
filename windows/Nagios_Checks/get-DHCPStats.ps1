
Param(
  [Parameter(Mandatory=$True)]
	[double]$Warning,
  [Parameter(Mandatory=$True)]
	[double]$Critical
)
# Standard Nagios error codes
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

#predefinning varibles
$exitcode = 0
$perforanceData = ""
$IssueSubnets = ""


try {
$DHCPServer = Get-DhcpServerv4Scope | select ScopeID  | Get-DhcpServerv4ScopeStatistics
}

catch {
Write-host "Unknown: DHCP Server Service is not running on the Server"
exit $returnStateUnknown
}

foreach ($subnet in $DHCPServer) {
    #do calculations for preformance data
    $totalIP = $subnet.AddressesFree + $subnet.InUse
    $CriticalIP = $totalIP * ($Critical * .01)
    $WarningIP = $totalIP * ($Warning * .01)

    $perforanceData = $perforanceData +  "DHCP_IP_" + $subnet.ScopeId +"=" + $subnet.InUse + ";" + $WarningIP + ";" + $CriticalIP + ";"+ "0 "
    
    if ($subnet.PercentageInUse -gt $warning){
        if ($IssueSubnets -eq "") {
            $IssueSubnets = $subnet.ScopeId
        }
        else {
            $IssueSubnets = [string]::concat($IssueSubnets, ", ", $subnet.ScopeId)
        }

        if ($exitcode -le $returnStateWarning) {
            $exitcode = $returnStateWarning
        }
        
        if ($subnet.PercentageInUse -gt $critical) {
            $exitcode = $returnStateCritical
        }
    }
            
}
    

if ($exitcode -eq $returnStateOK) {
	Write-Host "OK: All DHCP Scopes have sufficient free addresses in the IP Pool." "|" $perforanceData
	exit $returnStateOK
}
elseif ($exitcode -eq $returnStateWarning ) {
	Write-Host "Warning: The subnet(s)" $IssueSubnets "are low on IP addresses." "|" $perforanceData
	exit $returnStateWarning 
}

elseif ($exitcode -eq $returnStateCritical) {
	Write-Host "Error: The subnet(s)" $IssueSubnets "are low on IP addresses." "|" $perforanceData
	exit $returnStateCritical
}
else{
	Write-Host "Unknown: There is a problem getting the number of errors" 
	exit $returnStateUnknown
}

Write-Host "UNKNOWN script state, it should never get here"
exit $returnStateUnknown

# SIG # Begin signature block
# MIIMQwYJKoZIhvcNAQcCoIIMNDCCDDACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzlzmCFQpvs7p4wYV7aHhV76v
# 9/ygggm7MIIEaTCCA1GgAwIBAgIKKiEQkAAAAAAuJzANBgkqhkiG9w0BAQUFADAS
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
# IwYJKoZIhvcNAQkEMRYEFAHnNDnwyyrGPitJIBJNLqfPTr4sMA0GCSqGSIb3DQEB
# AQUABIIBAIMHgnO2qtMT1xLS4WwFD97cKh8nLEubjl0A4w1zVOcWKjuk2ZB3qeGV
# ONqnOH3iJCgOGniny6hF4Eo3uzNO/zHiyzdqwy3MQzK6MpZG38rvvRv/y8/Vc2xC
# z2mo39nJY/f5WiMchi1b87RxfoXmMIuwYvA0M7zGBO759CQC2aUePK2o2aWwT/3a
# O9NzNwuriY+Y1pl3JDZLBEdXT0J7/2v0v+T8PgEQVm2PmsCX+F0zIwcQN9FSitUH
# t5DTco/tg2gKf1mBoUNk7I5QmK43eAwCchvbwm6BkgmC9Zi5fvypVBXiHL6xsqLq
# 6UhHSKzenFplHUWVuFo3FQjy6Q3DJcc=
# SIG # End signature block
