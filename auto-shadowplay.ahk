#Requires AutoHotkey v2.0

Persistent
isWaiting := false      ; 标志位，表示是否在等待用户活动
SetTimer(CheckIdleTime, 1000) ; 每秒检测一次空闲时间


CheckIdleTime() {
    global isWaiting
    if (ReadShadowPlayReg() = "01000000" && !isWaiting && A_TimeIdlePhysical > 10000) {
        Send("^!{F9}") ; 按下 Ctrl+Alt+F9
        isWaiting := true ; 设置标志位，表示正在等待用户活动
        ; 等待用户再次有输入后再触发
        Sleep(1000)
        WaitForActivity() ; 等待用户恢复活跃
    }
}
WaitForActivity() {
    ; 等待用户输入
    while (A_TimeIdlePhysical >= 100) {
        Sleep(100) ; 每100毫秒检测一次
    }
    isWaiting := false ; 重置标志位
    ; 用户活跃后，重新发送快捷键
    if (ReadShadowPlayReg() = "00000000") {
		Send("^!{F9}")
    }
}
ReadShadowPlayReg(){
    ; 读取注册表键值
    try {
        return RegRead("HKEY_CURRENT_USER\Software\NVIDIA Corporation\Global\ShadowPlay\NVSPCAPS","{1B1D3DAA-601D-49E5-8508-81736CA28C6D}")
    } catch {
        return ""
    }
}
