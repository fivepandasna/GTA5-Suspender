global IsSuspended := false
global TimerActive := false

F1::
  if (IsSuspended) {
    SetTimer, ResumeProcess, Off
    TimerActive := false
    ProcSusp("GTA5_Enhanced.exe", 0)
    IsSuspended := false
  } else {
    ProcSusp("GTA5_Enhanced.exe", 1)
    IsSuspended := true
    TimerActive := true
    SetTimer, ResumeProcess, 8000
  }
Return

ResumeProcess:
  SetTimer, ResumeProcess, Off
  TimerActive := false
  if (IsSuspended) {
    ProcSusp("GTA5_Enhanced.exe", 0)
    IsSuspended := false
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