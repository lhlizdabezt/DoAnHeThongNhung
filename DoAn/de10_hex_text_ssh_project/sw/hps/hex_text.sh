#!/bin/sh
# Write text to 6 HEX displays via devmem on DE10-Standard.
# Addresses assume soc_system.qsys patched with pio_hex0..pio_hex5 at 0xFF200040..0xFF200090
set -eu
BASE=0xFF200000
A0=$((BASE + 0x40))
A1=$((BASE + 0x50))
A2=$((BASE + 0x60))
A3=$((BASE + 0x70))
A4=$((BASE + 0x80))
A5=$((BASE + 0x90))
seg() {
    case "$1" in
        0) echo 64 ;; 1) echo 121 ;; 2) echo 36 ;; 3) echo 48 ;;
        4) echo 25 ;; 5) echo 18 ;; 6) echo 2 ;; 7) echo 120 ;;
        8) echo 0 ;; 9) echo 16 ;;
        A) echo 8 ;; B) echo 3 ;; C) echo 70 ;; D) echo 33 ;;
        E) echo 6 ;; F) echo 14 ;; H) echo 9 ;; L) echo 71 ;;
        O) echo 64 ;; P) echo 12 ;; U) echo 65 ;; Y) echo 17 ;;
        '-') echo 63 ;; '_') echo 119 ;; ' ') echo 127 ;;
        *) echo 127 ;;
    esac
}
text="${1:-      }"
# uppercase, trim/pad to 6 chars
text=$(printf '%-6.6s' "$text" | tr '[:lower:]' '[:upper:]')
C0=$(printf '%s' "$text" | cut -c1)
C1=$(printf '%s' "$text" | cut -c2)
C2=$(printf '%s' "$text" | cut -c3)
C3=$(printf '%s' "$text" | cut -c4)
C4=$(printf '%s' "$text" | cut -c5)
C5=$(printf '%s' "$text" | cut -c6)
# left-to-right text on HEX5..HEX0 => write reverse order to addresses 0..5
V5=$(seg "$C0")
V4=$(seg "$C1")
V3=$(seg "$C2")
V2=$(seg "$C3")
V1=$(seg "$C4")
V0=$(seg "$C5")
for pair in "$A0:$V0" "$A1:$V1" "$A2:$V2" "$A3:$V3" "$A4:$V4" "$A5:$V5"; do
  addr=${pair%%:*}
  val=${pair##*:}
  devmem "$addr" 32 "$val" >/dev/null
  echo "$addr <- $val"
done
echo "OK text='$text'"
