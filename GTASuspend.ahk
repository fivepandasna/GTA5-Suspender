#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

global ProcessSuspended := 0
global SuspendTimer := 0

+Delete::
    Process, Exist, GTA5_Enhanced.exe
    if (ErrorLevel = 0)
        return
    
    if (ProcessSuspended) {
        SetTimer, ResumeProcess, Off
        RunWait, %A_ScriptDir%\pssuspend.exe -r GTA5_Enhanced.exe,, Hide
        ProcessSuspended := 0
    } else {
        RunWait, %A_ScriptDir%\pssuspend.exe GTA5_Enhanced.exe,, Hide
        ProcessSuspended := 1
        SetTimer, ResumeProcess, 10000
    }
return

ResumeProcess:
    SetTimer, ResumeProcess, Off
    RunWait, %A_ScriptDir%\pssuspend.exe -r GTA5_Enhanced.exe,, Hide
    ProcessSuspended := 0
return