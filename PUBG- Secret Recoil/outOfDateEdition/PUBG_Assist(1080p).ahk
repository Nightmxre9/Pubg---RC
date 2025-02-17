Configurações do Script

#NoEnv ; Recomendado para desempenho e compatibilidade com futuras versões do AutoHotkey.
#SingleInstance force ; Força o script a rodar apenas uma instância por vez.
;SetTitleMatchMode, 2 ; Define o modo para IfWinActive.
;'#IfWinActive, ahk_exe TslGame.exe; Garante que o Autofire funcione apenas no PUBG.

; Variáveis

ADS := 1 ; Valor para mira rápida.
Compensacao := 1 ; Define se a compensação é necessária.

V_AutoFire := 1 ; Define se o Autofire está ligado ou desligado.
comp := 8 ; Valor da compensação.

; Suspender se o mouse estiver visível

isMouseShown() ; Suspende o script quando o mouse estiver visível, como no inventário, menu ou mapa.
{
    StructSize := A_PtrSize + 16
    VarSetCapacity(InfoStruct, StructSize)
    NumPut(StructSize, InfoStruct)
    DllCall("GetCursorInfo", UInt, &InfoStruct)
    Resultado := NumGet(InfoStruct, 8)

    if Resultado > 1
        Return 1
    else
        Return 0
}

; Pulo Agachado

*$space::
    Random, atraso, 450, 525
    SendInput, {Space Down}{c down}
    Sleep, %atraso%
    SendInput, {c up}
    SendInput, {Space}  ; Para corrigir o bug de ficar agachado.
    SendInput, {Space down} ; Para corrigir o bug de nadar.
    KeyWait, Space
    SendInput, {Space up}
Return

; Configuração do Autofire

~$*NumPad1::(ADS = 0 ? (ADS := 1, ToolTip("Mira Rápida ON")) : (ADS := 0, ToolTip("Mira Rápida OFF")))

~$*NumPad2::(V_AutoFire = 0 ? (V_AutoFire := 1, ToolTip("Autofire ON")) : (V_AutoFire := 0, ToolTip("Autofire OFF")))

~$*Numpad0:: ; Reseta o valor de compensação para 0
    comp := 0
    ToolTip(comp)
Return

~$*Numpad8:: ; Reseta o valor de compensação para 8
    comp := 8
    ToolTip(comp)
Return

~$*NumpadAdd:: ; Aumenta o valor de compensação
    comp := comp + 1
    ToolTip(comp)
Return

~$*NumpadSub:: ; Diminui o valor de compensação
    comp := comp - 1
    ToolTip(comp)
Return

~$*NumpadEnter:: ; Exibe o valor de compensação
    ToolTip(comp)
Return

; Compensação

mouseXY(x, y) ; Move o mouse para baixo para compensar o recuo (valor na variável comp).
{
    DllCall("mouse_event", uint, 1, int, x, int, y, uint, 0, int, 0)
}

; Disparo Automático

~$*LButton:: ; Atira automaticamente quando o Autofire está ativado.
    if (V_AutoFire = 1)
    {
        Loop
        {
            GetKeyState, LButton, LButton, P
            if LButton = U
                Break
            MouseClick, Left,,, 1
            Gosub, RandomSleep

            if (Compensacao = 1) {
                Random, ramCom, -0.5, 0.0
                mouseXY(0, comp + ramCom) ; Se ativado, chama a compensação.
            }
        }
    } else {
        if (Compensacao = 1) {
            Random, ramCom, -1.0, 0.0
            mouseXY(0, comp + ramCom) ; Se ativado, chama a compensação.
        }
    }
Return

; Mira Rápida

$*RButton:: ; Mira rápida [padrão: botão direito do mouse]
    if ADS = 1
    {
        ; Se ativado, clica uma vez e clica novamente quando o botão for solto.
        SendInput, {RButton}
        SendInput {RButton Down}
        KeyWait, RButton
        SendInput {RButton Up}
    } else {
        ; Se não estiver ativado, mantém pressionado até o botão ser solto.
        SendInput {RButton Down}
        KeyWait, RButton
        SendInput {RButton Up}
    }
Return

; Dicas e Temporizadores

RandomSleep: ; Tempo aleatório entre os disparos do Autofire
    Random, aleatorio, 19, 25
    Sleep %aleatorio%-5
Return

RemoveToolTip: ; Remove as mensagens de ferramenta (tooltips).
    SetTimer, RemoveToolTip, Off
    ToolTip
Return

ToolTip(label) ; Função para exibir uma dica ao ativar, desativar ou alterar valores.
{
    ToolTip, %label%, 930, 650 ; Dicas são mostradas sob a mira para monitores FullHD.
    SetTimer, RemoveToolTip, 1300 ; Remove a dica após 1,3 segundos.
    Return
}

; Postado por Nightmxre9
