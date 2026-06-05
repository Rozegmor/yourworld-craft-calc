; ============================================
;   DMR Rapid Fire - YourWorld
;   Hold LMB = fast fire
; ============================================
;   F1      - ON / OFF
;   F2      - Faster (less delay)
;   F3      - Slower (more delay)
;   F4      - Show current delay
;   End     - Exit script
; ============================================

#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2

global enabled := false
global delay := 80

; Main polling loop - checks every 10ms if LMB is held
SetTimer(CheckFire, 10)

CheckFire() {
    if (!enabled || !GetKeyState("LButton", "P")) {
        return
    }
    ; LMB is held and enabled - click rapidly
    while (enabled && GetKeyState("LButton", "P")) {
        Click("Left")
        Sleep(delay)
    }
}

F1:: {
    global enabled
    enabled := !enabled
    ToolTip("DMR Rapid Fire: " (enabled ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

F2:: {
    global delay
    delay := Max(20, delay - 10)
    ToolTip("Delay: " delay "ms")
    SetTimer(() => ToolTip(), -1000)
}

F3:: {
    global delay
    delay := Min(300, delay + 10)
    ToolTip("Delay: " delay "ms")
    SetTimer(() => ToolTip(), -1000)
}

F4:: {
    MsgBox("Delay: " delay "ms`nState: " (enabled ? "ON" : "OFF"))
}

End:: ExitApp()
