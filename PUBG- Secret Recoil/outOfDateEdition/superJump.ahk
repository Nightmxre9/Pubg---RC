Configurações do Script

#NoEnv ; Recomendado para desempenho e compatibilidade com futuras versões do AutoHotkey.
#SingleInstance force ; Força o script a rodar apenas uma instância por vez.
SetTitleMatchMode, 2 ; Define o modo para IfWinActive.
;#ifwinactive, PLAYERUNKNOWN'S BATTLEGROUNDS ; Garante que o Autofire funcione apenas no PUBG.

; Pulo Agachado

*$space::
    Random, atraso, 450, 525
    SendInput, {Space Down}{c down}
    Sleep, %atraso%
    SendInput, {c up}
    SendInput, {Space}  ; Corrige o bug de continuar agachado.
    SendInput, {Space down} ; Corrige o bug ao nadar.
    KeyWait, Space
    SendInput, {Space up}
Return
