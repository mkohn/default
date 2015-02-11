# Standard Nagios error codes
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

#predefinning varibles
$exitcode = 0
$performanceData = ""
$Critical=100
$warning=99

add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

$ExchangeRawData = Get-MailboxDatabaseCopyStatus *  
$databaseFail = ""
foreach ($database in $ExchangeRawData){

       if (($database.CopyQueueLength -gt $Critical) -or ($database.ReplayQueueLength -gt $Critical)) {
           $exitcode = 2 
           
           #create collection of bad databases
           if ($databaseFail -eq "") {
                $databaseFail = $item.name
           }
           else {
                $databaseFail = [string]::concat($item.name + ", " + $databaseFail)
           } 
       }

       #Preformance data sections
       if ($performanceData -eq "") {
            $performanceData = [string]::concat($database.name+"_CopyQueue","=",$database.CopyQueueLength,";",$warning,";",$Critical,";0 ")
       }
       else {
            $performanceData = [string]::concat([string]::concat($database.name+"_CopyQueue","=",$database.CopyQueueLength,";",$warning,";",$Critical,";0") + ", " + $performanceData)
       }
       $performanceData = [string]::concat([string]::concat($database.name+"_ReplayQueue","=",$database.ReplayQueueLength,";",$warning,";",$Critical,";0") + ", " + $performanceData) 
    }

  
        

#Output data
if ($exitcode -eq $returnStateOK) {
	Write-Host "OK: All databases are replaying correctly" "|"  $performanceData
	exit $returnStateOK
}
elseif ($exitcode -eq $returnStateCritical) {
	Write-Host "Error:  There is an issue with the database(s)" $databaseFail "|" $performanceData
	exit $returnStateCritical
}
else{
	Write-Host "Unknown: There is a problem with some databases. Please look into the check and exchange ASAP!" 
	exit $returnStateUnknown
}

Write-Host "UNKNOWN script state, it should never get here"
exit $returnStateUnknown
