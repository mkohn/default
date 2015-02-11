# Standard Nagios error codes
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

#predefinning varibles
$exitcode = 0
$perforanceData = ""

$nodesdown = ""

# Lets loop through our computer list from computers
foreach ($computer in (Get-ClusterNode |  where state -eq "Paused").name) {
     try{
        if ($nodesdown -eq  ""){
            $nodesdown = $computer
            $exitcode = 1
        }
        else {
            $nodesdown = $nodesdown + ", " + $computer
        }

    }
    catch {
    $exitcode = 3
    Write-Host "Unknown: There is a problem geting the amount of space TOP CATCH" 
    
	exit $returnStateUnknown
    }

}

#Output data
if ($exitcode -eq $returnStateOK) {
	Write-Host "OK: There are no nodes paused."
	exit $returnStateOK
}
elseif ($exitcode -eq $returnStateWarning ) {
	Write-Host "Warning: There is/are" $nodesdown "currently paused."
	exit $returnStateWarning 
}

elseif ($exitcode -eq $returnStateCritical) {
	Write-Host "Error:  Not sure how you got an error because I do not set any."
	exit $returnStateCritical
}
else{
	Write-Host "Unknown: There is a problem geting the amount of space" 
	exit $returnStateUnknown
}

Write-Host "UNKNOWN script state, it should never get here"
exit $returnStateUnknown


# SIG # Begin signature block
# MIILTwYJKoZIhvcNAQcCoIILQDCCCzwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwgQ4W2nOryOOIkOjm7sAuAA+
# FfuggglIMIIEaTCCA1GgAwIBAgIKKiEQkAAAAAAuJzANBgkqhkiG9w0BAQUFADAS
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
# sxams8VMnwTFFLaAknk+cxpcJr3NKhnxY93mLtfNo70wtP0wggTXMIIEQKADAgEC
# Ago0dni+AAoACqp+MA0GCSqGSIb3DQEBBQUAMEMxFDASBgoJkiaJk/IsZAEZFgRj
# b3JwMRcwFQYKCZImiZPyLGQBGRYHdmlhZ29nbzESMBAGA1UEAxMJdmlhZ29nb04y
# MB4XDTE0MDcxODA0MTMwMVoXDTE1MDcxODA0MTMwMVowfDEUMBIGCgmSJomT8ixk
# ARkWBGNvcnAxFzAVBgoJkiaJk/IsZAEZFgd2aWFnb2dvMRAwDgYDVQQLEwdWSUFH
# T0dPMQ4wDAYDVQQLEwVVc2VyczEPMA0GA1UECxMGTG9uZG9uMRgwFgYDVQQDEw9Q
# aGlsaXBwIFNjaHJvdHQwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAOxsYcEt
# dmlr+lTZvkVGkyCvrN+UdyNqgCvwBf2RyO0oHLwBTA97FVuuqTUYFSg0vsJF4+ad
# jUw7fW6/2yGc+TXBCwjC/ezVzLs9WVJO5yJeb1EtXHgEU0mhK6NriNcFPikqhKQA
# 6zUmhSuPy0Mu0Bi8+/iVWTN69hQBY/YOYjXbAgMBAAGjggKXMIICkzAOBgNVHQ8B
# Af8EBAMCB4AwJQYJKwYBBAGCNxQCBBgeFgBDAG8AZABlAFMAaQBnAG4AaQBuAGcw
# HQYDVR0OBBYEFLr+yZzXRg3LOq89HA7t6Kv9CsapMB8GA1UdIwQYMBaAFKrhb2Ua
# rbmUxUv6HO3vICHONgF8MIIBCwYDVR0fBIIBAjCB/zCB/KCB+aCB9oaBt2xkYXA6
# Ly8vQ049dmlhZ29nb04yKDEwKSxDTj1OZXR3b3JrLTIsQ049Q0RQLENOPVB1Ymxp
# YyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24s
# REM9dmlhZ29nbyxEQz1jb3JwP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFz
# ZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludIY6aHR0cDovL25ldHdv
# cmstMi52aWFnb2dvLmNvcnAvQ2VydEVucm9sbC92aWFnb2dvTjIoMTApLmNybDCB
# vAYIKwYBBQUHAQEEga8wgawwgakGCCsGAQUFBzAChoGcbGRhcDovLy9DTj12aWFn
# b2dvTjIsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZp
# Y2VzLENOPUNvbmZpZ3VyYXRpb24sREM9dmlhZ29nbyxEQz1jb3JwP2NBQ2VydGlm
# aWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMDcGA1UdEQQwMC6gLAYKKwYBBAGCNxQCA6AeDBxQ
# aGlsaXBwLlNjaHJvdHRAdmlhZ29nby5jb3JwMA0GCSqGSIb3DQEBBQUAA4GBAEI9
# rb8Hy/Ncp3+gWOO4BSYPVF3kuAEQVx94QjvzBQX13KrshJoU2gEoSaMdDSCsFNI3
# dtjOQ7cvlh4eQXkD52Yg3yVDyCD7t0ovym4unJz6J7kbnp4gnEjJ1KBlcZANx6iK
# Cktp9MVYt60+77qpCIwM44fehC83aLXrX0ajNFXhMYIBcTCCAW0CAQEwUTBDMRQw
# EgYKCZImiZPyLGQBGRYEY29ycDEXMBUGCgmSJomT8ixkARkWB3ZpYWdvZ28xEjAQ
# BgNVBAMTCXZpYWdvZ29OMgIKNHZ4vgAKAAqqfjAJBgUrDgMCGgUAoHgwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUOMZ0
# rvGxFzM1vvB+Sd9A+gy2MrowDQYJKoZIhvcNAQEBBQAEgYCHw2UAOl2KBqn+DGPm
# cSvktpVqtNmX52XyrA9EH5Qhz0ostQSwnWG4BCLgiqrTgj9hM8bNkH+ZDDwRnOB9
# 9HYtz4isx8IJGmJv1k19CYiMD46bPGjOdgDBQhGyv6fPPl7baiJ0aPYeKQshqn7k
# aqD5+IrbKF8KU2SLWW5UctMzvQ==
# SIG # End signature block
