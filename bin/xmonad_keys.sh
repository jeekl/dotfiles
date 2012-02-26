#!/bin/sh
# file: xmonad_keys.sh

# show key bindings for XMonad using dzen2

fgCol=grey80
bgCol=grey5
titleCol=DarkOrange1
keyCol=yellow3

(
echo "         ^fg($titleCol)--- Key commands to control Xmonad ---^fg()";
sed -n \
 -e 's/^.*"\(M-[^"]*\)".*--[ \t]*\(.*\)$/^fg('$keyCol')\1^fg() \2/p' \
 -e 's/^[ \t]*$//p' \
 ~/.xmonad/xmonad.hs
) | cat -s \
| dzen2 -fg $fgCol -bg $bgCol -fn "Terminus" -x 2400 -y 0 -l 50 -ta l -w 450 -p \
-e 'onstart=togglecollapse,scrollhome;entertitle=uncollapse,grabkeys;\
enterslave=grabkeys;leaveslave=collapse,ungrabkeys;\
button2=togglestick;button3=exit:13;button4=scrollup;button5=scrolldown;\
key_Escape=ungrabkeys,exit;key_Next=scrolldown;key_Prior=scrollup'
