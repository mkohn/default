Import-Module ActiveDirectory
$Domain = "Viagogo.corp"
$Date = Get-Date -Format dd.MM.yyyy


$Dump = Search-ADAccount -SearchBase "INSERT OU SEARCH HERE" -AccountDisabled
$Dump | Select-Object name,Enabled


Do{

    $Answer = Read-Host "Should I move the disabled accounts to the proper OU? Y/N only"
   
}
While (!($Answer.ToUpper() -eq "Y" -or $Answer.ToUpper() -eq "N" ))


if ($Answer.ToUpper() -eq "Y"){
    $OU = New-ADOrganizationalUnit -Path "INSERT FINAL OU HERE" -Name "$Date" -PassThru
    $x=0;
    foreach ($User in $Dump){
        $x++

        Move-ADObject -Identity $User -TargetPath $OU
    }
    "I moved " + $x + " number of Users" 
}
else{
    "OK have a nice day"
} 