## Check-DFSR_nagios.ps1 script
## Rewritten/Modified: Matthew Kohn
## Written by: Mark A. Weaver
## Version: .5
## Date: 29.04.2013
## Purpose: This script will query the local WMI root for DFS replication groups and folders.  
##				It will then run DFS utilities to determine the number of files in the backlog on the
##          destination partners in the replication group.
##          
##          Returns nagios codes for alerting
## Input: None
#############################
## Updates:
##  20130428 Kohn: 	 Modified code to work with nagios
##  20090408 Weaver: Fixed issue where multiple events are generated throughout the execution
##  20090408 Weaver: Added BacklogFileCount to event message
##  20090409 Weaver: Fixed list of replication connections issue due to change in replication topology
##  20090507 Weaver: Added functionality to return results from all partners in the replication
##
##
 
## VARIBLES 
$BacklogOKLevel = 10 
$BacklogWarningLevel = 50 
 
$ComputerName = $env:ComputerName
## Query DFSR groups from the local MicrosftDFS WMI namespace.
$DFSRGroupWMIQuery = "SELECT * FROM DfsrReplicationGroupConfig"
$RGroups = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query $DFSRGroupWMIQuery
 
 
## Setup my variables
$ping = New-Object System.Net.NetworkInformation.Ping
 
try {
foreach ($Group in $RGroups)
{
	## Cycle through all Replication groups found
	$DFSRGFoldersWMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID='" + $Group.ReplicationGroupGUID + "'"
	$RGFolders = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query $DFSRGFoldersWMIQuery
 
	## Grab all connections associated with a Replication Group
	$DFSRConnectionWMIQuery = "SELECT * FROM DfsrConnectionConfig WHERE ReplicationGroupGUID='" + $Group.ReplicationGroupGUID + "'"
	$RGConnections = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query $DFSRConnectionWMIQuery	
	foreach ($Connection in $RGConnections)
	{
 
		$ConnectionName = $Connection.PartnerName.Trim()
		$IsInBound = $Connection.Inbound
		$IsEnabled = $Connection.Enabled
 
		## Do not attempt to look at connections that are Disabled
		if ($IsEnabled -eq $True)
		{  
			## If the connection is not ping-able, do not attempt to query it for Backlog info
			$Reply = $ping.send("$ConnectionName")
			if ($reply.Status -eq "Success")
			{
 
 				## Cycle through the Replication Folders that are part of the replication group and run DFSRDIAG tool to determine the backlog on the connection partners.
				foreach ($Folder in $RGFolders)
				{
					$RGName = $Group.ReplicationGroupName
					$RFName = $Folder.ReplicatedFolderName
 
					## Determine if current connect is an inbound connection or not, set send/receive members accordingly
					if ($IsInBound -eq $True)
					{
						$SendingMember = $ConnectionName
						$ReceivingMember = $ComputerName
					}
					else
					{
						$SendingMember = $ComputerName
						$ReceivingMember = $ConnectionName
					}
					   #$Out = $RGName + ":" + $RFName +  " - S:"+$SendingMember + " R:" + $ReceivingMember 
					   #Write-Host $Out
						## Execute the dfsrdiag command and get results back in the $Backlog variable
						$BLCommand = "dfsrdiag Backlog /RGName:'" + $RGName + "' /RFName:'" + $RFName + "' /SendingMember:" + $SendingMember + " /ReceivingMember:" + $ReceivingMember
						$Backlog = Invoke-Expression -Command $BLCommand
 
						$BackLogFilecount = 0
						foreach ($item in $Backlog)
						{
							if ($item -ilike "*Backlog File count*")
							{
								$BacklogFileCount = [int]$Item.Split(":")[1].Trim()
							}
 
						}
 
 
						if ($BacklogFileCount -le $BacklogOKLevel)
						{
							#Update Success Audit 
							$SuccessAudit += $RGName + ":" + $RFName + " is in sync with 0 files in the backlog from "+ $SendingMember + " to " + $ReceivingMember +".`n"					
							
 
						}
						elseif ($BacklogFilecount -le $BacklogWarningLevel)
						{
							#Update Warning Audit
							$WarningAudit += $RGName + ":" + $RFName + " has " + $BacklogFileCount + " files in the backlog from " + $SendingMember + " to " + $ReceivingMember + ".`n"
							
						}
						else
						{
							#Update Error Audit
							$ErrorAudit += $RGName + ":" + $RFName + " has " + $BacklogFilecount + " files in the backlog from " + $SendingMember + " to " + $ReceivingMember + ".`n"
						}
						#Write-Host + $Folder.ReplicatedFolderName "- " $BackLogFilecount -foregroundcolor $FGColor
					}
				}
				else
				{ 
				Write-Host $ConnectionName "is not pingable" 
				$NoPingMessage = "Server """ + $ConnectionName + """ could not be reached.`nPlease verify it is on the network and pingable."
				Write-Host 3
				#Write-Event $EventSource $NoPingEventID "Warning" $NoPingMessage "Application"
				}
			}
 
	}
 
}



 

 
if ($ErrorAudit -ne $Null)
{
	Write-Host "Error - " $BacklogFilecount  " waiting to be replicated"
	exit 2
}
if ($WarningAudit -ne $Null)
{
	Write-Host "Warning - " $BacklogFilecount " waiting to be replicated"
	exit 1
}

if ($SuccessAudit -ne $Null)
{
	Write-Host "OK - " $BacklogFilecount " waiting to be replicated"
	exit 0
}
}
Catch  [Exception] {
	Write-Host "Something Went Wrong"
	Write-Host "Catch"
}