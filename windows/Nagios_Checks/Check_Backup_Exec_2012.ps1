##############################################################################
#
# NAME: 	Check_Backup_Exec_2012.ps1
#
# AUTHOR: 	Matthew Kohn, Mark Del Vecchio
# EMAIL: 	it@hmcap.com	
#
# COMMENT:  Checks the number of errors in BackupExec 2012 
#
#			Return Values for NRPE:
#			return ok if 0 - OK (0)
#			If less than the warning max - WARNING (1)
#			if great than WarningMax - CRITICAL (2)
#			Script errors - UNKNOWN (3)
#
#
##############################################################################

#Quantity of errors before 
$WarningMax = 5
$CriticalMax = 6

# Standard Nagios error codes
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3


import-module "\program files\symantec\backup exec\modules\bemcli\bemcli"

$countCritical =  @(get-bealert -severity error).count

if ($countCritical -eq 0) {
	$perforanceData = "errors=" + $countCritical + ";" + $WarningMax + ";" + $CriticalMax + ";0"
	Write-Host "OK - No errors in BackupExec Jobs|"$perforanceData
	exit $returnStateOK
}
elseif ($countCritical -lt $WarningMax ) {
	$perforanceData = "errors=" + $countCritical + ";" + $WarningMax + ";" + $CriticalMax + ";0"
	Write-Host "Warning - Number of Job Errors: " $countCritical "|" $perforanceData
	exit $returnStateWarning 
}

elseif ($countCritical -ge $WarningMax) {
	Write-Host "Error - Number of Job Errors: " $countCritical "|" $perforanceDaat
	exit $returnStateCritical
}
else{
	Write-Host "Unknown: There is a problem getting the number of errors"
	exit $returnStateUnknown
}

Write-Host "UNKNOWN script state"
exit $returnStateUnknown
# SIG # Begin signature block
# MIIMQwYJKoZIhvcNAQcCoIIMNDCCDDACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUn7CcwPRvmXTmQp1Kz2OqN5cy
# RDCgggm7MIIEaTCCA1GgAwIBAgIKKiEQkAAAAAAuJzANBgkqhkiG9w0BAQUFADAS
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
# IwYJKoZIhvcNAQkEMRYEFAaPG4wv2Nm3NiroOmr4irJzKJgEMA0GCSqGSIb3DQEB
# AQUABIIBAGy1UU4oD5df4CN3P5FTZcebZIRo6HVS/VU/z2/F1HSXxI1Sd9tml+y1
# YeR6VP4QVxB0tPIVDKiTLNshjNPvW7wroj8qQZyqWJNVfcmB1jg8UcDSEGWEuvb/
# PIxvIo4MlIW0hVFYgGifzuwQZ3Nmb8Dk3Nnik4PAgqR++W/OuMb+UGvY6+cwULe8
# EoDH4UwXP+yBTTDUYNi+5GTxeXUmgLLmR9+p5KpfHM5iI7WSZyh6Z5Wt6lRP9gMv
# RlpuC6NP8jHunU2HlVHDcI7PkYp+P3Bi+CoFEc1NFg6jdp+Ror4B6WUroVU/Gg0i
# J+cEF6Mhf+Lp/71Tovwrb/y/6v7zXtU=
# SIG # End signature block
