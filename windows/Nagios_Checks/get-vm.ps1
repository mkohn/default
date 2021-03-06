#check of modules are imports
Import-Module hyper-v

$VMlist = ""
$dump = get-vm

foreach ($vm in $dump) {
	if ($VMlist -eq ""){
		$VMlist=$VM.name
	}
	else {
		$VMlist=$VMlist+","+$VM.name
	}
}

write-output $VMlist
# SIG # Begin signature block
# MIIMQwYJKoZIhvcNAQcCoIIMNDCCDDACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6vCT34FRxAGaVWnxVQkGlO3P
# 79agggm7MIIEaTCCA1GgAwIBAgIKKiEQkAAAAAAuJzANBgkqhkiG9w0BAQUFADAS
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
# AgpKPQ5AAAoACGLKMA0GCSqGSIb3DQEBBQUAMEMxFDASBgoJkiaJk/IsZAEZFgRj
# b3JwMRcwFQYKCZImiZPyLGQBGRYHdmlhZ29nbzESMBAGA1UEAxMJdmlhZ29nb04y
# MB4XDTE0MDIyNjIxMDI1NFoXDTE1MDIyNjIxMDI1NFowbTEUMBIGCgmSJomT8ixk
# ARkWBGNvcnAxFzAVBgoJkiaJk/IsZAEZFgd2aWFnb2dvMRAwDgYDVQQLEwdWSUFH
# T0dPMQswCQYDVQQLEwJJVDEdMBsGA1UEAxMUTWF0dGhldyBLb2huIChBZG1pbikw
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC3YWL1i/LBnTyd/pgiD+9x
# foQQCpVDtl4393m8JgBJ6em1KeGPtTEluqceEFWysUWfmar3hRKeCEItvC8c123b
# Kgwp+g4aPxVFdl/T7OvpTUkFYoKzSCY2nwOkY+QtVIyB/mIw4UuanNeN3P1iPDxh
# OUd744VW3QdmIcSct+ufu4mxF8tmMtnkJgqUDrmoJJDvB3ewOAIxrEOzNJw5XCUN
# r9BlGGe1Eey/Ygqb4ZXbWObvduMX5JJZJoaOEOwTdgjovPhGONkTnQNJMrirODby
# A8cwTYRJJyAvtYaiR8FymF6ZCtp9T7lAr0S95iJoSNH6idpNota7vc7uXjajUDGn
# AgMBAAGjggKVMIICkTAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBpAGcAbgBp
# AG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0O
# BBYEFFnvX+3P2phQC/7BY5v0hgykykz4MB8GA1UdIwQYMBaAFKrhb2UarbmUxUv6
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
# BgkqhkiG9w0BAQUFAAOBgQCoprR9rxtA0+g2AacQVMgAuCS1QP1cDHga0DwAJwTX
# /cKhFkukzxuNE6qr50oIA3TXZIEvKyyFDiHv+lvGQjOF3xHSfawcTpw7GLwiWC4K
# 5T2Em7h+KOmp56tR3gjxuy5xabZbAOzXvp0fBd44P5a6Wq8krSy/bPbW+vYQ0t5Z
# dTGCAfIwggHuAgEBMFEwQzEUMBIGCgmSJomT8ixkARkWBGNvcnAxFzAVBgoJkiaJ
# k/IsZAEZFgd2aWFnb2dvMRIwEAYDVQQDEwl2aWFnb2dvTjICCko9DkAACgAIYsow
# CQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# IwYJKoZIhvcNAQkEMRYEFJQ7k8uOecQrWUMyftwKSnL0o+1AMA0GCSqGSIb3DQEB
# AQUABIIBAJBdFx1qoLzaK096gXR3jgen21OfcDVSEAn0V0x7Pn6rPEIKgsQQT18M
# UZ+UAapapGUAeYcH5sbrtwaa4/+gEE8KMm7E8NrKbGuwOFhkkLUaDnJjMk7tWPw1
# yWg4cvEUzhyVf7AYpmnr0bYo6znbLk5r9gXy6ryuNmVzjemE7ROD+YZ+YkbYYPL4
# KHHZ24IpuzUIPI3PvvSaEP8Rm2N2ZiQthDu0dxNITr/02FE8g2xn31N6fuakOKfQ
# U8Azh5hK9QnxtqRNHC7ELftUzc3DJ/Lt/begmd2dmghnW35h/z3wi3ldxtb5tSE5
# Xbrp6O5NdR4pP7/if0C61/tv4wMxm50=
# SIG # End signature block
