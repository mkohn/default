add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

#globally set varibles
#$AllSites = ""
$AllSites = ""
$Sizes = ""
$pserver = ""
$EXServersSecondary = ""
$DefaultPath="Exchange\"
$dc = ""
$OWA = "Default Offline Address Book (Ex2012)"

#foreach site and database size (hence the two loops)
$Sites = $Allsites.split(",")
foreach ($site in $Sites) {
    $size = $sizes.split(",")
    foreach ($db in $size){ 
        $DBNAME = [String]$site + [String]$db

        #makes the databases
        
            $RemoteLogPathBase = '\\' + [string]$pserver + "\L$\" + $DefaultPath 
            $RemoteDBPathBase = '\\' + [string]$pserver + "\M$\" + $DefaultPath
            
            #Test to see if the base directory exists if not creates them          
            if (!(Test-path $RemoteLogPathBase)) {
                new-item -ItemType Directory -Path $RemoteLogPathBase -WhatIf
            }
            if (!(Test-path $RemoteDBPath)) { 
                new-item -ItemType Directory -Path $RemoteDBPath 
            }

            #Creating Folders
            $RemoteLogPath = $RemoteLogPathBase +  $DBNAME
            $RemoteDBPath = $RemoteDBPathBase  + $DBNAME

            $LocalLogPath = "L:\" + $DefaultPath +  $DBNAME
            $LocalDBPath = "M:\" + $DefaultPath + $DBNAME + "\" + $DBNAME +".edb"

            #Make Folders
            new-item -ItemType Directory -Path $RemoteDBPath 
            new-item -ItemType Directory -Path $RemoteLogPath 
          
            #sets limit based on database name
            if($db -eq "DBS001") {
                $IssueWarningQuota = 2.8GB
                $ProhibitSendQuota = 3GB
                $ProhibitSendReceiveQuota = 3.2GB
            } elseif ($db -eq "DBM001"){
                $IssueWarningQuota = 4.8GB
                $ProhibitSendQuota = 5GB
                $ProhibitSendReceiveQuota = 5.2GB
            }
            elseif ($db -eq "DBL001"){
                $IssueWarningQuota = 48.8GB
                $ProhibitSendQuota = 50GB
                $ProhibitSendReceiveQuota = 52GB
            }
            else {
                write-host "Problem with database names"
                exit 
            }
            
            #Setup Mailbox
            New-mailboxdatabase -name $DBNAME -Server $pserver -EdbFilePath $LocalDBPath -LogFolderPath $LocalLogPath -DomainController $DC -OfflineAddressBook $OWA
            set-mailboxdatabase -Identity $DBNAME -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -ProhibitSendQuota $ProhibitSendQuota -IssueWarningQuota $IssueWarningQuota -DomainController $DC -OfflineAddressBook $OWA 
			
            sleep 10
            mount-database -Identity $DBNAME -DomainController $dc
        
        
        #pause of 2 minutes done to allow the exchange server to upload all relevent information to the Domain Controller
        sleep 120

        $secondaryEX = $EXServersSecondary.Split(",")
        foreach( $Server_Repla in $secondaryEX) { 
            $RemoteLogPathBase = '\\' + [string]$Server_Repla + "\L$\" + $DefaultPath 
            $RemoteDBPathBase = '\\' + [string]$Server_Repla + "\M$\" + $DefaultPath
            
                      
            if (!(Test-path $RemoteLogPathBase)) {
                new-item -ItemType Directory -Path $RemoteLogPathBase 
            }
            if (!(Test-path $RemoteDBPath)) { 
                new-item -ItemType Directory -Path $RemoteDBPath 
            }

            #Creating Folders
            $RemoteLogPath = $RemoteLogPathBase +  $DBNAME
            $RemoteDBPath = $RemoteDBPathBase  + $DBNAME

            new-item -ItemType Directory -Path $RemoteDBPath 
            new-item -ItemType Directory -Path $RemoteLogPath 

            $Server_Replica_String = [string]$Server_Repla
           
            #setup Database in DAG
            Add-MailboxDatabaseCopy -Identity $DBNAME -MailboxServer $Server_Replica_String -DomainController $dc
        }
    }
}
 