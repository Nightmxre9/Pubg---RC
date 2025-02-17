Configurações do Script
Postado por Nightmxre9

#NoEnv ; Recomendado para desempenho e compatibilidade com futuras versões do AutoHotkey.
#SingleInstance force ; Garante que o script só seja executado uma vez por vez.
SetTitleMatchMode, 2 ; Define o modo para a janela ativa.
#ifwinactive, PLAYERUNKNOWN'S BATTLEGROUNDS ; Garante que o AutoFire só funcione no PUBG.

; Variáveis

ADS := 1 ; Valor para mira rápida.
Compensacao := 1 ; Valor para compensação ao disparar automaticamente.

vAutoFire := 1 ; Valor para ativação e desativação do AutoFire.
isMouseShown() ; Valor para suspender quando o mouse estiver visível.
comp := 0 ; Valor da compensação.

armaID := 0 ; Valor para a arma em uso. 0:padrão, 4:M4, SCAR-L, 5:UMP, 6:M16, 7:AKM.
isX4usado := 0 ; Define se a luneta x4 está equipada.

compensacaoArmas := Array()
compensacaoArmas[0] := Array(7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 9, 9, 9, 9, 8.9, 8.9, 8.9, 8.9, 8.9, 8.9, 8.9) ; AKM
compensacaoArmas[1] := Array(20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 37, 37, 37, 37, 28, 28, 28, 28, 28, 28, 28) ; AKM com x4
compensacaoArmas[2] := Array(5, 5, 5, 5, 5, 5, 5, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6) ; M4, SCAR-L
compensacaoArmas[3] := Array(26, 26, 26, 26, 26, 26, 26, 45, 45, 45, 45, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29) ; M4, SCAR-L com x4
compensacaoArmas[4] := Array(5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 6.9, 6.9, 6.9, 6.9, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7.1, 7, 7, 7) ; UMP9
compensacaoArmas[5] := Array(25, 25, 25, 25, 25, 25, 25, 35, 35, 35, 35, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28) ; UMP9 com x4
compensacaoArmas[6] := Array(8, 8, 8, 8, 8, 8, 8, 10.2, 10.2, 10.2, 10.2, 10.2, 10.2, 10.2, 10.2, 8, 8, 8) ; M16
compensacaoArmas[7] := Array(26, 26, 26, 26, 26, 26, 26, 45, 45, 45, 45, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29) ; M16 com x4

; Suspende o script se o mouse estiver visível (ex: inventário, menu, mapa).

isMouseShown()
{
    StructSize := A_PtrSize + 16
    VarSetCapacity(InfoStruct, StructSize)
    NumPut(StructSize, InfoStruct)
    DllCall("GetCursorInfo", UInt, &InfoStruct)
    Result := NumGet(InfoStruct, 8)

    if Result > 1
        Return 1
    else
        Return 0
}

Loop
{
    if isMouseShown() == 1
        Suspend On
    else
        Suspend Off
    Sleep 1
}

; Pulo com Agachamento

~$*space::
    Random, delay, 400, 600
    SendInput, {Space Down}{c down}{Space up}
    Sleep, %delay%
    SendInput, {c up}
Return

; Configuração do AutoFire

~$*b:: ; Ativa/Desativa AutoFire ao pressionar "B".
    if vAutoFire = 0
    {
        vAutoFire = 1 
        ToolTip("AutoFire ATIVADO")
    }
    else
    {
        vAutoFire = 0 
        ToolTip("AutoFire DESATIVADO")
    }
Return

~$*NumPad1::(ADS = 0 ? (ADS := 1, ToolTip("ADS ATIVADO")) : (ADS := 0, ToolTip("ADS DESATIVADO")))

~$*NumPad3::(isX4usado = 0 ? (isX4usado := 1, ToolTip("x4 ATIVADO")) : (isX4usado := 0, ToolTip("x4 DESATIVADO")))

~$*Numpad4:: ; Define M4 como arma ativa.
    armaID := 4
    ToolTip("M4")
Return    

~$*Numpad5:: ; Define UMP como arma ativa.
    armaID := 5
    ToolTip("UMP")
Return    

~$*Numpad6:: ; Define M16 como arma ativa.
    armaID := 6
    ToolTip("M16")
Return    

~$*Numpad7:: ; Define AKM como arma ativa.
    armaID := 7
    ToolTip("AKM")
Return    

; Compensação de Recuo

mouseXY(x,y) ; Move o mouse para compensar o recuo.
{
    DllCall("mouse_event", uint, 1, int, x, int, y, uint, 0, int, 0)
}

; Disparo Automático

~$*LButton::
    if vAutoFire = 1
    {
        passo := 0
        Loop
        {
            GetKeyState, LButton, LButton, P
            if LButton = U
                Break
            MouseClick, Left,,, 1
            Gosub, RandomSleep

            if (Compensacao = 1)
            {
                if (armaID = 0)
                    mouseXY(0, comp)
                else
                {
                    tempComp := isX4usado ? armaID * 2 + 1 : armaID * 2
                    mouseXY(0, compensacaoArmas[tempComp][passo])
                    passo := (passo = compensacaoArmas[tempComp].Length() ? passo : passo + 1)
                }
            }
        }
    }
Return

; Mira Rápida

$*RButton::
    if ADS = 1
    {
        SendInput {RButton Down}
        SendInput {RButton Up}
        KeyWait, RButton
        SendInput {RButton Down}
        SendInput {RButton Up}
    }
    else
    {
        SendInput {RButton Down}
        KeyWait, RButton
        SendInput {RButton Up}
    }
Return

; Ferramentas e Temporizadores

RandomSleep:
    Random, random, 14, 25
    Sleep %random%-5
Return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    tooltip
Return

ToolTip(label)
{
    ToolTip, %label%, 930, 650
    SetTimer, RemoveToolTip, 1000
    Return
}