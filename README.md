# AutoBackUp-Using-AutoIT
This mini project features an auto back up system on windows written using AutoIt scritpting language.

Dependencies:
 - Computer must have winrar installed.
 - Must set to the windows scheduler to run the compiled backup.exe on the time u want to back up.
 - Computer must stay on during back up. In an event that it is turned off files might not be backed up completly.
 - Must include the following libraries for these specific files
   * Backup.au3
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
       
    * Setter.au3
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
  
      
  ******************  IF MISSING ONE OF THE LIBRARIES PLS VISIT AUTOIT WEBSITE AND FIND IT THERE :) ********************
  
  Features:
    - Works on Removable media as long as its plugged in before the back up starts and drive letter doesnt change.
    - Auto delete of old backup files.
    - Can add multiple directories to back up and place them into one single rar file as output.
    - Has a log system that post the time, date, status and history of the back up on a txt file.
     
