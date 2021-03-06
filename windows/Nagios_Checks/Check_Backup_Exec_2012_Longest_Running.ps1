##############################################################################
#
# NAME: 	Check_Backup_Exec_2012_Longest_Running.ps1
#
# AUTHOR: 	Matthew Kohn
# EMAIL: 	MatthewKohn@gmail.com	
#
# COMMENT:  Checks the longest running time of a running backup in BackupExec 2012 
#
#			Return Values for NRPE:
#			return ok if 0 - OK (0)
#			If less than the WarninginHours - WARNING (1)
#			if great than CirticalnHours - CRITICAL (2)
#			Script errors - UNKNOWN (3)
#
#
##############################################################################
Param(
  [Parameter(Mandatory=$True)]
	[double]$WarninginHours,
  [Parameter(Mandatory=$True)]
	[double]$CirticalinHours
)
# Standard Nagios error codes
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

#predefinning varibles
$exitcode = $returnStateUnknown
$perforanceData = ""
$JobRunning = ""
$JobTime = 0

import-module "\program files\symantec\backup exec\modules\bemcli\bemcli"

$runningJobs =  @(Get-BEActiveJobDetail)
if ([string]::IsNullOrEmpty($runningJobs)) {
	$perforanceData = "hours=" + 0+ ";" + $WarninginHours + ";" + $CirticalinHours + ";0"
	Write-Host "OK: No running jobs" "|" $perforanceData
	exit $returnStateOK
}

#Checks to see if each job is longer than the imputed time and return the longest job
foreach ( $job in $runningJobs){

	if ($job.elapsedTime.TotalHours -lt $WarninginHours)
		{
			if ($JobTime -lt $job.elapsedTime.TotalHours){
				$JobTime = $job.elapsedTime.TotalHours
				$JobRunning = $job.Name + ": "  + $job.StartTime
				$exitcode = $returnStateOK
			}
		}
	elseif ($job.elapsedTime.TotalHours -lt $CirticalinHours)
		{
			if ($JobTime -lt $job.elapsedTime.TotalHours){
				$JobTime = $job.elapsedTime.TotalHours
				$JobRunning = $job.Name + ": "  + $job.StartTime
				$exitcode = $returnStateWarning
			}
		}
	elseif ($job.elapsedTime.TotalHours -gt $CirticalinHours)
		{
			if ($JobTime -lt $job.elapsedTime.TotalHours){
				$JobTime = $job.elapsedTime.TotalHours
				$JobRunning = $job.Name + ": "  + $job.StartTime
				$exitcode = $returnStateCritical
			}
		}

}
$perforanceData = "hours=" + $JobTime + ";" + $WarninginHours + ";" + $CirticalinHours + ";0"

if ($exitcode -eq $returnStateOK) {
	Write-Host "OK: The longest running job is: " $JobRunning " and running for " $JobTime "|" $perforanceData
	exit $returnStateOK
}
elseif ($exitcode -eq $returnStateWarning ) {
		Write-Host "Warning: The longest running job is: " $JobRunning " and running for " $JobTime "|" $perforanceData
	exit $returnStateWarning 
}

elseif ($exitcode -eq $returnStateCritical) {
	Write-Host "Error: The longest running job is: " $JobRunning " and running for " $JobTime "|" $perforanceData
	exit $returnStateCritical
}
else{
	Write-Host "Unknown: There is a problem getting the number of errors" 
	exit $returnStateUnknown
}

Write-Host "UNKNOWN script state, it should never get here"
exit $returnStateUnknown
