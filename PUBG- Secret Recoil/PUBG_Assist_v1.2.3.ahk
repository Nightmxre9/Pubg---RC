; Configurações do Script

#NoEnv ; Recomendado para desempenho e compatibilidade com futuras versões do AutoHotkey.
#SingleInstance force ; Força o script a ser executado apenas uma vez por vez.
#IfWinActive, ahk_exe TslGame.exe ; Garante que o autofire funcione apenas no PUBG.

; Variáveis
querRantesdeL := 1 ; Se deseja mirar antes do autofire ou da compensação.

compensacao := 8 ; Valor da compensação do autofire.

tbt := 11 ; Tempo entre disparos.

SCAL_TBT := 12 ; Tempo entre disparos da SCAL.
SCAL_COMP := 8 ; Compensação para SCAL.

AK_TBT := 13 ; Tempo entre disparos da AK.
AK_COMP := 8 ; Compensação para AK.

M4_TBT := 11 ; Tempo entre disparos da M4.
M4_COMP := 8 ; Compensação para M4.

GROZA_TBT := 10 ; Tempo entre disparos da GROZA.
GROZA_COMP := 5 ; Compensação para GROZA.

UMP_TBT := 12 ; Tempo entre disparos da UMP.
UMP_COMP := 7 ; Compensação para UMP.

; Suspender se o mouse estiver visível
mouseVisivel() {
    TamanhoEstrutura := A_PtrSize + 16
    VarSetCapacity(InfoStruct, TamanhoEstrutura)
    NumPut(TamanhoEstrutura, InfoStruct)
    DllCall("GetCursorInfo", UInt, &InfoStruct)
    Resultado := NumGet(InfoStruct, 8)
    return Resultado > 1 ? 1 : 0
}

Loop {
    if (mouseVisivel() == 1) {
        Suspend On
    } else {
        Suspend Off
    }
    Sleep 1
}

; Configuração do Autofire
~$*Numpad4::
    tbt := M4_TBT
    compensacao := M4_COMP
    ExibirMensagem("M4")
return

~$*Numpad5::
    tbt := UMP_TBT
    compensacao := UMP_COMP
    ExibirMensagem("UMP")
return

~$*Numpad6::
    tbt := SCAL_TBT
    compensacao := SCAL_COMP
    ExibirMensagem("SCAL")
return

~$*Numpad7::
    tbt := AK_TBT
    compensacao := AK_COMP
    ExibirMensagem("AK")
return

~$*Numpad9::
    tbt := GROZA_TBT
    compensacao := GROZA_COMP
    ExibirMensagem("GROZA")
return

~$*Numpad0::
    compensacao := 0
    ExibirMensagem("sem compensação")
return

~$*Numpad8::
    compensacao := 8
    ExibirMensagem(compensacao)
return

~$*NumpadAdd::
    compensacao := compensacao + 1
    ExibirMensagem(compensacao)
return

~$*NumpadSub::
    compensacao := compensacao - 1
    ExibirMensagem(compensacao)
return

~$*NumpadEnter::
    querRantesdeL := !querRantesdeL
    ExibirMensagem(querRantesdeL ? "Granadas Melhoradas ATIVADAS" : "Granadas Melhoradas DESATIVADAS")
return

; Compensação
moverMouse(x,y) {
    DllCall("mouse_event", uint, 1, int, x, int, y, uint, 0, int, 0)
}

; Autofire
~$*LButton::
    if (GetKeyState("RButton") || querRantesdeL = 0) {
        Loop {
            GetKeyState, LButton, LButton, P
            if LButton = U
                Break
            Random, aleatorio, tbt - 1, tbt + 1
            Sleep %aleatorio%
            Random, variacaoComp, -2.0, 0.0
            moverMouse(0, compensacao + variacaoComp)
        }
    }
return

; Mensagens e Temporizadores
SonoAleatorio:
    Random, aleatorio, 19, 25
    Sleep %aleatorio%-5
return

RemoverMensagem:
    SetTimer, RemoverMensagem, Off
    tooltip
return

ExibirMensagem(texto) {
    ToolTip, %texto%, 930, 650
    SetTimer, RemoverMensagem, 1300
    return
}
