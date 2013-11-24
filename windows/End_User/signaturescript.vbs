' script from http://bradmarsh.net/index.php/2008/05/14/ad-based-outlook-email-signature-for-2003-and-2007-continued/
'====================
'
' VBScript: <Signatures.vbs>
' AUTHOR: Peter Aarts
' Contact Info: peter.aarts@l1.nl
' Version 2.04
' Date: January 20, 2006
' Moddified By Brad Marsh Now works with both 2003 and 2007 outlook 
' Contact: gentex@tpg.com.au 
' Date 19 feb 08 
' Tested on Vista, XP, XP64 and office 2003 and 2007. 
' NOTE will not work that well with various email accounts
'====================

'Option Explicit
On Error Resume Next

Dim qQuery, objSysInfo, objuser
Dim FullName, EMail, Title, PhoneNumber, MobileNumber, FaxNumber, OfficeLocation, Department
Dim web_address, FolderLocation, HTMFileString, StreetAddress, Town, State, Company
Dim ZipCode, PostOfficeBox, UserDataPath

' Read LDAP(Active Directory) information to asigns the user’s info to variables.
'====================
Set objSysInfo = CreateObject("ADSystemInfo")
objSysInfo.RefreshSchemaCache
qQuery = "LDAP://" & objSysInfo.Username
Set objuser = GetObject(qQuery)

FullName = objuser.displayname
EMail = objuser.mail
User = objuser.sAMAccountName
Company = objuser.Company
Title = objuser.title
PhoneNumber = objuser.TelephoneNumber
FaxNumber = objuser.FaxNumber
OfficeLocation = objuser.physicalDeliveryOfficeName
StreetAddress = objuser.streetaddress
PostofficeBox = objuser.postofficebox
Department = objUser.Department
ZipCode = objuser.postalcode
Town = objuser.l
MobileNumber = objuser.TelephoneMobile
State = objuser.st
web_address = "{Website}" 

' This section creates the signature files names and locations.
'====================
' Corrects Outlook signature folder location. Just to make sure that
' Outlook is using the purposed folder defined with variable : FolderLocation
' Example is based on Dutch version.
' Changing this in a production enviremont might create extra work
' all employees are missing their old signatures
'====================
Dim objShell, RegKey, RegKey07, RegKeyParm
Set objShell = CreateObject("WScript.Shell")
RegKey = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\General"
RegKey07 = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Common\General"
RegKey07 = RegKey07 & "\Signatures"
RegKey = RegKey & "\Signatures"
objShell.RegWrite RegKey , "AD_hmcap" 

objShell.RegWrite RegKey07 , "AD_hmcap"

UserDataPath = ObjShell.ExpandEnvironmentStrings("%appdata%")
FolderLocation = UserDataPath &"\Microsoft\AD_hmcap\" 
HTMFileString = FolderLocation & "hmcap.htm" 
TXTFileString = FolderLocation & "hmcap.txt" 

' This section disables the change of the signature by the user. AND HAS BEEN COMMENTED OUT, uncommented it at your risk
'====================
'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\MailSettings\NewSignature" , "L1-Handtekening" — change this to your desired setting (note I did not use these settings they were commented out

'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\MailSettings\ReplySignature" , "L1-Handtekening" — change this to your desired setting (note I did not use these settings they were commented out

'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\Options\Mail\EnableLogging" , "0", "REG_DWORD"

' This section checks if the signature directory exits and if not creates one.
'====================
Dim objFS1
Set objFS1 = CreateObject("Scripting.FileSystemObject")
If (objFS1.FolderExists(FolderLocation)) Then
Else
Call objFS1.CreateFolder(FolderLocation)
End if

' The next section builds the signature file
'====================
Dim objFSO
Dim objFile,afile
Dim aQuote
aQuote = chr(34)

' This section builds the HTML file version
'====================
Set objFSO = CreateObject("Scripting.FileSystemObject")

' This section deletes to other signatures.
' These signatures are automaticly created by Outlook 2003.
'====================
'Set AFile = objFSO.GetFile(Folderlocation&"HMcap.rtf")
'aFile.Delete
'Set AFile = objFSO.GetFile(Folderlocation&"Hmcap.txt")
'aFile.Delete

Set objFile = objFSO.CreateTextFile(HTMFileString,True)
objFile.Close
Set objFile = objFSO.OpenTextFile(HTMFileString, 2)


'– HERE WE ARE STARTING HOW THE HTML LOOKS –

'NOTES: 
'always start a new line of code with objfile.write "
'Close every line with " & vbCrLf

'the rest is simple HTML, you will need to change this to suite your requirements

'–start of HTML  Body Started, you can copy this–

objfile.write "<!DOCTYPE HTML PUBLIC " & aQuote & "-//W3C//DTD HTML 4.0 Transitional//EN" & aQuote & ">" & vbCrLf
objfile.write "<HTML><HEAD><TITLE>Microsoft Office Outlook Signature</TITLE>" & vbCrLf
objfile.write "<META http-equiv=Content-Type content=" & aQuote & "text/html; charset=windows-1252" & aQuote & ">" & vbCrLf
objfile.write "<META content=" & aQuote & "MSHTML 6.00.3790.186" & aQuote & " name=GENERATOR></HEAD>" & vbCrLf
objfile.write "<body>" & vbCrLf

'– Start of Style and open and close of head, you can copy this you may want to change the style a little –


objfile.write "    <head> <style type=text/css>" & vbCrLf
objfile.write "}" & vbCrLf 
objfile.write ".style4 {" & vbCrLf
objfile.write "    text-decoration: none;" & vbCrLf
objfile.write "    font-family:Garamond,serif;" & vbCrLf
objfile.write "    font-variant:small-caps;" & vbCrLf
objfile.write "    color:black;" & vbCrLf
objfile.write "    letter-spacing:.4pt" & vbCrLf
objfile.write "}" & vbCrLf 
objfile.write "</style></head>" & vbCrLf'


'–Start of the actual Signature, CHANGE this, however make sure you keep the Variables in tack, just more them to suite you variables in this signature are and should look like below when inserted into the HTML:



objfile.write "<font size =4><b>"& FullName &  "</b> </font>" & Title & "<br>" & vbCrLf
objfile.write "<font size =4><b>Highmount</b></font> Global Wealth Management" & "<br>" &  vbCrLf
objfile.write StreetAddress & ", " & Town & ", " & State & ", " & ZipCode & "<br>" & vbCrLf
objfile.write "<b>T</b>: " & PhoneNumber & " <b>F</b>: " & FaxNumber & " <b>E</b>: <a href=mailto:" & EMail & ">"& User &"@hmcap.com" &"</a> <b>W</b>: <a href=http://www.hmcap.com>www.hmcap.com</a> " & "<br>" &  vbCrLf
objfile.write "<br>" & vbCrLf
objfile.write "<font size =4><span style='font-family:Arial,sans-serif;font-variant:small-caps;color:green'>please consider the environment before you print this email.</span></font>" & "<br>" & "<br>" &  vbCrLf

objFile.Close


'–END OF HTML–

'–Start of Txt

Set objFile = objFSO.CreateTextFile(TXTFileString,True)
objFile.Close
Set objFile = objFSO.OpenTextFile(TXTFileString, 2)
'I will highlight them red so you can see where they actully are used within the HTML, I did not use all of the variables listed above.
objfile.write FullName & " " & Title & vbCrLf
objfile.write "Highmount Global Wealth Management" & vbCrLf
objfile.write StreetAddress  &  " "  &  Town   &  ", "  &  State  &  ", "  &  ZipCode & vbCrLf
objfile.write "T: "  &  PhoneNumber  &  " F: "  &  FaxNumber   &  " E: "  &  EMail  &  " W: www.hmcap.com" & vbCrLf
objfile.write vbCrLf
objfile.write "Please consider our environment before printing this email."


objFile.Close

' ===========================
' This section readsout the current Outlook profile and then sets the name of the default Signature
' ===========================
' Use this version to set all accounts
' in the default mail profile
' to use a previously created signature

Call SetDefaultSignature("hmcap","") 

' Use this version (and comment the other) to
' modify a named profile.
'Call SetDefaultSignature _
' ("Signature Name", "Profile Name")

Sub SetDefaultSignature(strSigName, strProfile)
Const HKEY_CURRENT_USER = &H80000001
strComputer = "."

If Not IsOutlookRunning Then
Set objreg = GetObject("winmgmts:" & _
"{impersonationLevel=impersonate}!\\" & _
strComputer & "\root\default:StdRegProv")
strKeyPath = "Software\Microsoft\Windows NT\" & _
"CurrentVersion\Windows " & _
"Messaging Subsystem\Profiles\"
' get default profile name if none specified
If strProfile = "" Then
objreg.GetStringValue HKEY_CURRENT_USER, _
strKeyPath, "DefaultProfile", strProfile
End If
' build array from signature name
myArray = StringToByteArray(strSigName, True)
strKeyPath = strKeyPath & strProfile & _
"\9375CFF0413111d3B88A00104B2A6676"
objreg.EnumKey HKEY_CURRENT_USER, strKeyPath, _
arrProfileKeys
For Each subkey In arrProfileKeys
strsubkeypath = strKeyPath & "\" & subkey
objreg.SetBinaryValue HKEY_CURRENT_USER, _
strsubkeypath, "New Signature", myArray
objreg.SetBinaryValue HKEY_CURRENT_USER, _
strsubkeypath, "Reply-Forward Signature", myArray
Next
Else
strMsg = "Please shut down Outlook before running this script." 


MsgBox strMsg, vbExclamation, "SetDefaultSignature"
End If
End Sub

Function IsOutlookRunning()
strComputer = "."
strQuery = "Select * from Win32_Process " & _
"Where Name = 'Outlook.exe’"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _
& strComputer & "\root\cimv2")
Set colProcesses = objWMIService.ExecQuery(strQuery)
For Each objProcess In colProcesses
If UCase(objProcess.Name) = "OUTLOOK.EXE" Then
IsOutlookRunning = True
Else
IsOutlookRunning = False
End If
Next
End Function

Public Function StringToByteArray _
(Data, NeedNullTerminator)
Dim strAll
strAll = StringToHex4(Data)
If NeedNullTerminator Then
strAll = strAll & "0000"
End If
intLen = Len(strAll) \ 2
ReDim arr(intLen - 1)
For i = 1 To Len(strAll) \ 2
arr(i - 1) = CByte _
("&H" & Mid(strAll, (2 * i) - 1, 2))
Next
StringToByteArray = arr
End Function

Public Function StringToHex4(Data)
' Input: normal text
' Output: four-character string for each character,
' e.g. "3204" for lower-case Russian B,
' "6500" for ASCII e
' Output: correct characters
' needs to reverse order of bytes from 0432
Dim strAll
For i = 1 To Len(Data)
' get the four-character hex for each character
strChar = Mid(Data, i, 1)
strTemp = Right("00" & Hex(AscW(strChar)), 4)
strAll = strAll & Right(strTemp, 2) & Left(strTemp, 2)
Next
StringToHex4 = strAll

End Function

 