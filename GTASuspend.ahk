#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

global ProcessSuspended := 0
global CountdownValue := 10
global CountdownGui

Gui, Countdown:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
Gui, Countdown:Color, 000000
Gui, Countdown:Font, s48 bold, Arial
Gui, Countdown:Add, Text, cRed vCountdownText w200 h100 Center, 10
WinSet, TransColor, 000000 200
Gui, Countdown:+Owner

+Delete::
    Process, Exist, GTA5_Enhanced.exe
    if (ErrorLevel = 0)
        return
    
    if (ProcessSuspended) {
        SetTimer, UpdateCountdown, Off
        SetTimer, ResumeProcess, Off
        Gui, Countdown:Hide
        RunWait, %A_ScriptDir%\pssuspend.exe -r GTA5_Enhanced.exe,, Hide
        ProcessSuspended := 0
    } else {
        RunWait, %A_ScriptDir%\pssuspend.exe GTA5_Enhanced.exe,, Hide
        ProcessSuspended := 1
        CountdownValue := 10
        UpdateCountdownDisplay()
        CenterCountdownOnScreen()
        Gui, Countdown:Show, NoActivate
        SetTimer, UpdateCountdown, 1000
        SetTimer, ResumeProcess, 10000
    }
return

UpdateCountdown:
    CountdownValue := CountdownValue - 1
    UpdateCountdownDisplay()
    if (CountdownValue <= 0) {
        SetTimer, UpdateCountdown, Off
        Gui, Countdown:Hide
    }
return

UpdateCountdownDisplay() {
    GuiControl, Countdown:, CountdownText, %CountdownValue%
}

CenterCountdownOnScreen() {
    SysGet, MonitorCount, MonitorCount
    SysGet, MonitorPrimary, MonitorPrimary
    SysGet, MonitorWorkArea, MonitorWorkArea, %MonitorPrimary%
    Gui, Countdown:+LastFound
    WinGetPos,,, GuiWidth, GuiHeight
    X := (MonitorWorkAreaRight - MonitorWorkAreaLeft - GuiWidth) // 2
    Y := (MonitorWorkAreaBottom - MonitorWorkAreaTop - GuiHeight) // 2
    Gui, Countdown:Show, NoActivate x%X% y%Y%
}

ResumeProcess:
    SetTimer, UpdateCountdown, Off
    SetTimer, ResumeProcess, Off
    Gui, Countdown:Hide
    RunWait, %A_ScriptDir%\pssuspend.exe -r GTA5_Enhanced.exe,, Hide
    ProcessSuspended := 0
return
