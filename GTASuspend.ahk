global IsSuspended := false
global TimerActive := false
global CountdownSeconds := 8

global CountdownGui
Gui, Countdown:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
Gui, Countdown:Color, 000000
Gui, Countdown:Font, s48 bold, Arial
Gui, Countdown:Add, Text, cRed vCountdownText w200 h100 Center, %CountdownSeconds%
WinSet, TransColor, 000000 200
Gui, Countdown:+Owner

F1::
  if (IsSuspended) {
    SetTimer, UpdateCountdown, Off
    SetTimer, ResumeProcess, Off
    TimerActive := false
    ProcSusp("GTA5_Enhanced.exe", 0)
    IsSuspended := false
    Gui, Countdown:Hide
  } else {
    ProcSusp("GTA5_Enhanced.exe", 1)
    IsSuspended := true
    TimerActive := true
    
    ; Reset and start countdown
    CountdownSeconds := 8
    GuiControl, Countdown:, CountdownText, %CountdownSeconds%
    
    ; Center the GUI on screen
    SysGet, MonitorWorkArea, MonitorWorkArea
    GuiWidth := 200
    GuiHeight := 100
    XPos := (MonitorWorkAreaRight - GuiWidth) / 2
    YPos := (MonitorWorkAreaBottom - GuiHeight) / 2
    Gui, Countdown:Show, x%XPos% y%YPos% w%GuiWidth% h%GuiHeight% NoActivate
    
    SetTimer, UpdateCountdown, 1000
    SetTimer, ResumeProcess, 8000
  }
Return

UpdateCountdown:
  CountdownSeconds -= 1
  if (CountdownSeconds <= 0) {
    SetTimer, UpdateCountdown, Off
  } else {
    GuiControl, Countdown:, CountdownText, %CountdownSeconds%
  }
Return

ResumeProcess:
  SetTimer, UpdateCountdown, Off
  SetTimer, ResumeProcess, Off
  TimerActive := false
  if (IsSuspended) {
    ProcSusp("GTA5_Enhanced.exe", 0)
    IsSuspended := false
    Gui, Countdown:Hide
  }
Return

ProcSusp(PID_or_Name, Flag:=0) {
  PID := (InStr(PID_or_Name, ".")) ? ProcExist(PID_or_Name) : PID_or_Name
  h := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
  If !h
    Return -1
  If Flag
    DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
  Else
    DllCall("ntdll.dll\NtResumeProcess", "Int", h)
  DllCall("CloseHandle", "Int", h)
}

ProcExist(PID_or_Name="") {
  Process Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
  Return Errorlevel
}