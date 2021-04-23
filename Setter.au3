#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <Misc.au3>
#include <WinAPIFiles.au3>

Global $g_iButtonCount = 0
Global $FieldCount = 1
Global $Dir = @ScriptDir&"\"&"Settings.ini"
;~ First Browse Button Top Location
Global $g_iTop = 112

Global $g_aBrowse[0][2], $g_sBrowseFolder, $g_sSelectFolder, $g_sBrowseFields

Global $g_hMainForm = GUICreate("Auto Backup", 453, 180, 900, 247)

Global $g_sBackupLocation = GUICtrlCreateLabel("Location of the Backup Folder:", 8, 8, 169, 19)
    GUICtrlSetFont($g_sBackupLocation, 10, 400, 0, "Calibri")
    GUICtrlSetResizing($g_sBackupLocation,$GUI_DOCKALL)
Global $g_idBrowseButton = GUICtrlCreateButton("Browse", 8, 32, 65, 17)
    GUICtrlSetResizing($g_idBrowseButton,$GUI_DOCKALL)
Global $g_idBrowseField = GUICtrlCreateEdit("", 80, 32, 329, 17, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
    GUICtrlSetResizing($g_idBrowseField,$GUI_DOCKAlL)

   Local $BackupFolderRead = IniRead ($Dir, "Direct", "BackUpDirectory", "" )
   GUICtrlSetData($g_idBrowseField,$BackupFolderRead)


Global $g_idFolderBackup = GUICtrlCreateLabel("Locations of the Folder to be Backup:", 8, 80, 205, 19)
    GUICtrlSetFont($g_idFolderBackup, 10, 400, 0, "Calibri")
    GUICtrlSetResizing($g_idFolderBackup,$GUI_DOCKALL)
Global $g_idBackupButton = GUICtrlCreateButton("OK", 200, 144, 73, 25)
Global $g_idExpandButton = GUICtrlCreateButton("+", 416, 112, 17, 17)
        GUICtrlSetResizing($g_idExpandButton,$GUI_DOCKALL)

;~ Add the first Browse/Field Controls
    AddField()

GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $g_idExpandButton
            If $g_iButtonCount <= 3 Then
               ExpandGUI()
               AddField()
               $g_iButtonCount += 1
            Else
               MsgBox($MB_SYSTEMMODAL, "Notice", "Maximum Number of Locations Reached")
            EndIf


	    Case $g_idBrowseButton
		   Local $BackupFolder = DirectoryBrowse()
		   GUICtrlSetData($g_idBrowseField,$BackupFolder)


        Case $g_idBackupButton
		    DataToIni()
		    IniWrite($Dir,"Direct","IterationNumber",$FieldCount - 1)
            GUIDelete($g_hMainForm)
			Exit

        Case Else

			If $nMsg == 9 Then
			   $g_sSelectFolder = DirectoryBrowse()
			   GUICtrlSetData($g_aBrowse[0][1], $g_sSelectFolder)

			ElseIf $nMsg == 11 Then
			   $g_sSelectFolder = DirectoryBrowse()
			   GUICtrlSetData($g_aBrowse[1][1], $g_sSelectFolder)

			ElseIf $nMsg == 13 Then
			   $g_sSelectFolder = DirectoryBrowse()
			   GUICtrlSetData($g_aBrowse[2][1], $g_sSelectFolder)

			ElseIf $nMsg == 15 Then
			   $g_sSelectFolder = DirectoryBrowse()
			   GUICtrlSetData($g_aBrowse[3][1], $g_sSelectFolder)

			ElseIf $nMsg == 17 Then
			   $g_sSelectFolder = DirectoryBrowse()
			   GUICtrlSetData($g_aBrowse[4][1], $g_sSelectFolder)


			EndIf

    EndSwitch
WEnd

Func ExpandGUI()
   Local $GuiPosition = WinGetPos($g_hMainForm) ; Get the GUI coördinates
   WinMove($g_hMainForm, "", $GuiPosition[0], $GuiPosition[1], $GuiPosition[2], $GuiPosition[3] + 30)
EndFunc

Func AddField()
    Local $iArrayAdd = _ArrayAdd($g_aBrowse, GUICtrlCreateButton("Browse", 8, $g_iTop, 65, 17) & "|" & GUICtrlCreateEdit("", 80, $g_iTop, 329, 17, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN)))
    GUICtrlSetResizing($g_aBrowse[$iArrayAdd][0],$GUI_DOCKALL)
    GUICtrlSetResizing($g_aBrowse[$iArrayAdd][1],$GUI_DOCKAlL)
    $g_iTop += 28

	Local $BackupLocationRead = IniRead ($Dir, "Direct", "Location" &$FieldCount, "" )
    GUICtrlSetData(-1,$BackupLocationRead)
	$FieldCount = $FieldCount + 1

EndFunc


Func DirectoryBrowse()
   Local $num = 1
    ; Create a constant variable in Local scope of the message to display in FileSelectFolder.
    Local Const $sMessage = "Select a folder"

    ; Display an open dialog to select a file.
    Local $sFileSelectFolder = FileSelectFolder($sMessage, "")
    If @error Then
        ; Display the error message.
  ;      MsgBox($MB_SYSTEMMODAL, "", "No folder was selected.")
    Else
        ; Display the selected folder.
   ;     MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $sFileSelectFolder)
	 EndIf
	 Return $sFileSelectFolder

EndFunc

Func DataToIni()

   Local $Location,$BackupDirectory,$Counter


   For $Counter = 1 To $FieldCount-1 Step + 1
	  $Location = GUICtrlRead($g_aBrowse[$Counter -1][1])
	  IniWrite($Dir,"Direct","Location" &$Counter,$Location)
   Next

   $BackupFolder = GUICtrlRead($g_idBrowseField)
   IniWrite($Dir,"Direct","BackUpDirectory",$BackupFolder)

EndFunc