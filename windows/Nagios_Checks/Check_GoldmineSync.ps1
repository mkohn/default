param(
	[string]$Site
)

$culture = New-Object System.Globalization.CultureInfo("en-us")

# Get all needed info from both SQL and System
$SQLOutput = sqlcmd -H {SQLDB} -U nagios -P "{Password}" -d {Database} -Q "select LASTSESS from GSSITES where SNAME = '$Site'"
$CurrentTime = Get-Date

#Converts the SQLoutput to a date time format (SQLout is an array)
$SQLTime= [datetime]::ParseExact($SQLOutput[2], "yyyyMMddHH:mm", $culture)


#does the comparison by adding time to last sql sync time and adding a given number of hours. if true it exits
if (  $CurrentTime -le $SQLTime.AddHours(6)) {
	Write-Host "Ok: Last sync was at "  $SQLTime 
	exit 0
	}
elseif ($CurrentTime -le $SQLTime.AddHours(72) ) {
	Write-Host "Warning: Last sync was at "  $SQLTime 
	exit 1
	}
elseif ($CurrentTime -gt $SQLTime.AddHours(72)) {
	Write-Host "Error: Last sync was at "  $SQLTime 
	exit 2
	}

else {
	Write-Host "Unknown: Problem with the script, run it manually"
	exit 3
	}


