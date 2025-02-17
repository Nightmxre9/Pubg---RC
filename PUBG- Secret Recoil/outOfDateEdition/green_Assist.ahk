 Assistência para PUBG
 Postado por Nightmxre9

#NoEnv                        ; Recomendado para desempenho e compatibilidade com futuras versões do AutoHotkey.
#SingleInstance force         ; Garante que o script só seja executado uma vez por vez.
SetTitleMatchMode, 2          ; Define o modo para a janela ativa.
;#ifwinactive, PLAYERUNKNOWN'S BATTLEGROUNDS  ; Garante que o AutoFire só funcione no PUBG.

ADS := 1                      ; Valor para mira rápida.
isAimming := 0
isMouseShown()                ; Valor para suspender quando o mouse estiver visível.

isMouseShown()                ; Suspende o script quando o mouse está visível, ex: inventário, menu, mapa.
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

*$space::
    Random, delay, 450, 525
    SendInput, {Space Down}{c down}
    Sleep, %delay%
    SendInput, {c up}
    SendInput, {Space}       ; Para corrigir o bug de ficar agachado.
    SendInput, {Space down}  ; Para corrigir o bug de nadar.
    KeyWait, Space
    SendInput, {Space up}
Return

$*RButton::                   ; Mira rápida [padrão: botão direito do mouse]
    if ADS = 1
    {
        ; Se estiver ativo, clica uma vez e clica novamente quando o botão for solto.
        SendInput, {RButton}
        SendInput {RButton Down}
        KeyWait, RButton
        SendInput {RButton Up}
    } 
    else 
    {
        ; Se não, mantém pressionado até o botão ser solto.
        SendInput {RButton Down}
        KeyWait, RButton
        SendInput {RButton Up}
    }
Return

~$*NumPad1::(ADS = 0 ? (ADS := 1, ToolTip("ADS ATIVADO")) : (ADS := 0, ToolTip("ADS DESATIVADO")))

RandomSleep:                  ; Tempo aleatório entre disparos de AutoFire
    Random, random, 14, 25
    Sleep %random%-5
Return

RemoveToolTip:                ; Usado para remover mensagens de ferramenta (tooltips).
    SetTimer, RemoveToolTip, Off
    tooltip
Return

ToolTip(label)                ; Função para exibir um tooltip ao ativar, desativar ou alterar valores.
{
    ToolTip, %label%, 930, 650  ; Tooltips são exibidos abaixo da mira para monitores FullHD.
    SetTimer, RemoveToolTip, 1300  ; Remove o tooltip após 1,3 segundos.
    Return
}
