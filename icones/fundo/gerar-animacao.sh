#!/usr/bin/env bash
# Pré-renderiza o fundo animado: gera os 16 quadros do pisca-pisca dos LEDs
# (gerar-datacenter.sh <tema> quadro N), rasteriza cada um em PNG e junta
# tudo num WebP animado sem perdas, 0,25 s por quadro, em loop.
#
# Uso: gerar-animacao.sh <claro|escuro>   (cria datacenter-<tema>.webp)
# Precisa de rsvg-convert (librsvg) e img2webp (libwebp). No NixOS:
#   nix-shell -p librsvg libwebp --run './gerar-animacao.sh escuro'
set -euo pipefail

TEMA=${1:?uso: $0 <claro|escuro>}
AQUI=$(dirname "$0")
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

QUADROS=()
for n in $(seq 0 15); do
  "$AQUI/gerar-datacenter.sh" "$TEMA" quadro "$n" > "$TMP/$n.svg"
  rsvg-convert "$TMP/$n.svg" -o "$TMP/$n.png"
  QUADROS+=("$TMP/$n.png")
done

img2webp -loop 0 -lossless -d 250 "${QUADROS[@]}" -o "$AQUI/datacenter-$TEMA.webp" > /dev/null
