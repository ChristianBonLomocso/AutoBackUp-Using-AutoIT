#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <Misc.au3>
#include <Date.au3>
#include "Notify.au3"
#include <File.au3>
#include <array.au3>

Opt("TrayAutoPause", 0)


Local $return
Local $Dir = @ScriptDir&"\"&"Settings.ini"
Global $LogFile = @ScriptDir&"\"&"Logs.txt"

Local $Location[5]
Local $Loc

Local $to = IniRead ($Dir, "Direct", "BackUpDirectory", "" )	;asa i save
Local $IterationCount = IniRead($Dir,"Direct","IterationNumber","")
Local $Counter = 0
Local $FileName
Global $GB = 0

Global $Logs = FileOpen($LogFile,$FO_APPEND)

Local $count = StringLen($to) ;Count the length of the string to cut the first 3
Local $DriveLocation = StringTrimRight($to,$count-3)   ;remove the extra characters after the 3rd char

FileWrite($LogFile,"**** Start of Log Date: "&Date()&"   Time: "&Time()&" ******"&@CRLF)


CheckSize()
For $Counter = 0 To $IterationCount-1 Step +1
   $Location[$Counter] = IniRead($Dir,"Direct","Location" &$Counter+1,"")
Next



While 1

   If $GB <= 60 Then
	  FileWrite($LogFile,"Free Space is Less than 60GB"&@CRLF)
	  CheckStorage()
	  CheckSize()
   Else
      For $Counter = 0 To $IterationCount-1 Step +1
		 $Loc = $Location[$Counter]
		 $FileName = StringSplit($Loc,'\', $STR_ENTIRESPLIT)
		 Local $iFileExists = FileExists($Loc)
		 If $iFileExists Then
			Backup($Loc,$FileName[$FileName[0]])
			_Notify_Show(@AutoItExe, "Backup Succesfull", "Retracts after 5 secs", 5, 0)
			Sleep(5000)
		 Else
		 EndIf
	  Next
		 FileWrite($LogFile,"****End of Log******"&@CRLF&@CRLF)
		 FileClose($Logs)
		 Exit
   EndIf

WEnd


Func CheckSize()
   Local $iFreeSpace = DriveSpaceFree($DriveLocation) ; gets the drive free storage in MB
   If @error Then
	  FileWrite($LogFile,"Error reading Hardrive size on: "&$DriveLocation&@CRLF)
   Else
	  $GB = $iFreeSpace / 1024 ; Converts it to GB
	  $GB = Round($GB,0) ;Remove all decimal places
	  FileWrite($LogFile,"Free Space of: "&$GB&"GB On: "&$DriveLocation&@CRLF)
EndIf

EndFunc

Func Date()
   Local $date = _NowDate()
   $date = StringReplace($date, "/", "-")
   Return $date

EndFunc

Func Time()
   Local $time = _NowTime(5)
   $time = StringReplace($time, ":", "-")
    Return $time
EndFunc



Func Backup($loc,$Name)
   $time = Time()
   $date = Date()

   Local $DateTime = $date &" "& $time &" "&$Name
   Local $FileName = String ($DateTime)

   Local $to = IniRead ($Dir, "Direct", "BackUpDirectory", "" )	;asa i save


   $loc = $loc & "\"
   $to = $to & "\"

   $BackUpLocation = $to &""& $FileName   ;asa i save plus filename

   FileWrite($LogFile,"Creating BackUp For: " &$Name&@CRLF)
   RunWait (@ComSpec & ' /c  ""%ProgramFiles%\WinRaR\Rar.exe" a -ep1 -r -y "' &$BackUpLocation& '" "' & $loc& '"',"",@SW_HIDE)
   if @error then
	   FileWrite($LogFile,"Backup error on: " &$Name&@CRLF)
	  Exit
   Else
	  FileWrite($LogFile,"Backup Successfull on: " &$Name&@CRLF)
   EndIf


  Sleep(3000)

EndFunc


Func CheckStorage()
 ;  Local $sSearchPath = "C:\Users\localuser\Desktop\Pinnger - Copy\"

   Local $sSearchPath = IniRead ($Dir, "Direct", "BackUpDirectory", "" )	;asa i save
   $sSearchPath = $sSearchPath & "\"

   Local $aFileList = _FileListToArray($sSearchPath, "*.*")
   Local $aExtendedFileList[$aFileList[0]+1][2]
   Local $del

   for $i=1 to $aFilelist[0]
	  $aExtendedFileList[$i][0] = $aFileList[$i]
	  $aExtendedFileList[$i][1] =  StringTrimRight(FileGetTime($sSearchPath & $aFileList[$i] , $FT_MODIFIED, 1), 6)
   next

   _ArraySort($aExtendedFileList, 0,0,0, 1)

   Local $OldestFile = $aExtendedFileList[1][1]

   For $i=1 to $aFilelist[0]
	  If $aExtendedFileList[$i][1] == $OldestFile Then
		 $del = $sSearchPath & $aExtendedFileList[$i][0]
		 $FileDelete = FileDelete($del)
		 If $FileDelete Then
			FileWrite($LogFile,$del&" Has been deleted"&@CRLF)
		 Else
			FileWrite($LogFile,"Error Deleting File: "&$del&@CRLF)
		 EndIf
	  EndIf
   Next

EndFunc

