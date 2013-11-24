#THINGS to set
$rootPath="C:\temp\accountdump\"
$searchroot="" 


#Don't touch below

#import Quest Module
Add-PSSnapin Quest.ActiveRoles.ADManagement
 
#Set some variables  
$today=Get-Date -Format MMddyyyy
$location=$rootpath + $today

#test to see if path exist if it does removes it
if (test-path $location){
	remove-item -path $location -recurse -force
}
#creates folder
new-item -type directory -path $location

#gets users
$listofaccounts = Get-QADUser -SearchRoot $searchroot | select -property SamAccountName

#for each user it gets the groups
foreach ($line in $listofaccounts){
	$name=$line.SamAccountName
	$path =  $location + "\" + $name + ".txt"
	$name + " " + $today | Out-File $path
	Get-QADMemberOf $name -Indirect | Select-Object name,GroupType,Description,Notes | Out-File -append $path
}


# SIG # Begin signature block
# MIIHTgYJKoZIhvcNAQcCoIIHPzCCBzsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUp4ZV1Zt/jus3+Uwic7uTussb
# 4+egggVAMIIFPDCCBCSgAwIBAgIKRxvVuwABAAABtjANBgkqhkiG9w0BAQUFADBK
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
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIToCZEWK9a8/TUdjJW+43uJxnje
# MA0GCSqGSIb3DQEBAQUABIGAivqnWKMQERK+e6t8vy6AyYIq2JiCGzxyq5eXieQx
# 6aTuL4fyYFf6LLs27en79vzJCllTs9h8/Udqliur7uZJj196K9jzvM9c54aTCCOF
# wzhmpKgj+9cZmwtIAnWf8eQcevsDX4veRWjTvZy1bsChfB1chxuExTKh4q6o+ftU
# w+k=
# SIG # End signature block
