#!/usr/bin/env bash
# Gera o fundo de datacenter (pixel art) em SVG, nas versões clara e escura
# da paleta da Tama. Um ladrilho de 800x440 (uma fileira de 4 racks) que se
# repete sem emendas.
#
# A fileira mistura duas topologias (TIA-942):
#   - ToR: o rack tem dois switches no topo (Top of Rack); cada equipamento
#     liga num deles e os ToRs sobem para a bandeja de cabos (uplink).
#   - EoR/MoR: racks EDA (Equipment Distribution Area) não têm switch, só
#     servidores e um patch panel; um tronco sobe do patch panel para a
#     bandeja e desce no rack HDA (Horizontal Distribution Area), que tem
#     só switches, ligados aos patch panels do topo dele.
#
# Os equipamentos ocupam a largura toda do rack e preenchem os 15U de cima a
# baixo. Cada cabo sai da porta do equipamento, vai para a sua faixa no lado
# direito e sobe até a porta logo acima no topo do rack; quanto mais baixo o
# equipamento, mais à direita a faixa, então nenhum cabo cruza outro.
#
# Uso: gerar-datacenter.sh <claro|escuro> [estatico] > arquivo.svg
#   estatico: LEDs acesos, sem animação (a versão usada no celular, onde
#   redesenhar o fundo a cada piscada trava a página).
set -euo pipefail

ESTATICO=0
[[ "${2:-}" == estatico ]] && ESTATICO=1

case "${1:-}" in
  escuro)
    FUNDO="#0C0E12"; BANDEJA="#171A21"; MOLDURA="#20252F"; TRILHO="#3A4150"; FURO="#0C0E12"
    CORPO="#2B3240"; FRENTE="#232936"; PORTA="#0C0E12"; ROTULO="#B9BEC6"; CEGO="#1B2029"
    PAINEL="#3A4150"
    VERDE="#5A9E72"; AZUL="#6E8CC8"; DOURADO="#D9A752"; VINHO="#D0607A"; CINZA="#7D848C"
    ABRACADEIRA="#B9BEC6"; BRILHO="#FFFFFF"; BRILHO_A="0.25"
    ;;
  claro)
    FUNDO="#C9CDD3"; BANDEJA="#B3B8C0"; MOLDURA="#4A5260"; TRILHO="#7D848C"; FURO="#3E4654"
    CORPO="#F5F5F5"; FRENTE="#E2E5EA"; PORTA="#1E2533"; ROTULO="#3E4654"; CEGO="#D9DDE3"
    PAINEL="#B9BEC6"
    VERDE="#3A7550"; AZUL="#4261A1"; DOURADO="#86601A"; VINHO="#8B2C45"; CINZA="#7D848C"
    ABRACADEIRA="#1E2533"; BRILHO="#FFFFFF"; BRILHO_A="0.35"
    ;;
  *) echo "uso: $0 <claro|escuro> [estatico]" >&2; exit 1 ;;
esac

r() { printf '<rect x="%s" y="%s" width="%s" height="%s" fill="%s"/>\n' "$1" "$2" "$3" "$4" "$5"; }
t() { printf '<text x="%s" y="%s" fill="%s">%s</text>\n' "$1" "$2" "$ROTULO" "$3"; }

# LEDs piscam como tráfego de rede: cada um recebe um ritmo (a-d) e um
# atraso (e-g) que variam de LED para LED; um em cada cinco fica aceso fixo.
# Todos os tempos (durações, pontos de troca e atrasos) caem numa grade de
# 0,25 s: a imagem só muda 4 vezes por segundo, e o navegador não precisa
# redesenhar o fundo a cada quadro.
N_LED=0
led() { # x y largura altura cor
  local ritmos=(a b c d) atrasos=(e f g)
  N_LED=$((N_LED + 1))
  if (( ESTATICO || N_LED % 5 == 0 )); then
    r "$@"
  else
    printf '<rect class="%s %s" x="%s" y="%s" width="%s" height="%s" fill="%s"/>\n' \
      "${ritmos[$(( (N_LED * 7) % 4 ))]}" "${atrasos[$(( (N_LED * 5) % 3 ))]}" "$1" "$2" "$3" "$4" "$5"
  fi
}

LEDS=("$VERDE" "$VERDE" "$DOURADO" "$VERDE" "$AZUL" "$VERDE" "$VERDE" "$DOURADO")

# Geometria ----------------------------------------------------------------
LARGURA_LADRILHO=800
LARGURA=132         # largura útil do rack (os equipamentos ocupam toda)
U=24                # altura de 1U (20px de equipamento + 4px de folga)
Y0=56               # primeiro U
TOTAL_U=15          # Y0 + 15 × 24 = 416, fim da área útil do rack
Y_FIM=$((Y0 + TOTAL_U * U))

# Equipamentos (x = borda interna esquerda do rack) ------------------------

base() { # x y altura
  r "$1" "$2" "$LARGURA" "$3" "$CORPO"
  r $(($1 + 2)) $(($2 + 2)) $((LARGURA - 4)) $(($3 - 4)) "$FRENTE"
}

porta_lateral() { # x y_centro: a porta de onde sai o cabo do equipamento
  r $(($1 + 84)) $(($2 - 3)) 6 6 "$PORTA"
}

switch() { # x y rotulo semente colunas [colunas_de_uplink]
  # As primeiras colunas_de_uplink ficam sem LED: por elas passam os cabos
  # de uplink, e um LED piscando embaixo de um cabo pareceria o cabo mexendo.
  local x=$1 y=$2 s=$4 n=$5 u=${6:-0} i
  base "$x" "$y" 20
  t $((x + 4)) $((y + 13)) "$3"
  for i in $(seq 0 $((n - 1))); do
    r $((x + 26 + i * 8)) $((y + 4)) 6 5 "$PORTA"
    r $((x + 26 + i * 8)) $((y + 11)) 6 5 "$PORTA"
    (( i < u )) && continue
    led $((x + 28 + i * 8)) $((y + 5)) 2 2 "${LEDS[$(( (i + s) % 8 ))]}"
    led $((x + 28 + i * 8)) $((y + 12)) 2 2 "${LEDS[$(( (i * 3 + s) % 8 ))]}"
  done
}

patch_panel() { # x y: passivo, portas sem LED
  local x=$1 y=$2 i
  r "$x" "$y" "$LARGURA" 20 "$PAINEL"
  r $((x + 2)) $((y + 2)) $((LARGURA - 4)) 16 "$CORPO"
  t $((x + 4)) $((y + 13)) "PP"
  for i in $(seq 0 7); do
    r $((x + 26 + i * 8)) $((y + 4)) 6 5 "$PORTA"
    r $((x + 26 + i * 8)) $((y + 11)) 6 5 "$PORTA"
  done
}

roteador() { # x y
  local x=$1 y=$2 i
  base "$x" "$y" 20
  t $((x + 4)) $((y + 13)) "RT"
  for i in 0 1 2; do led $((x + 24 + i * 5)) $((y + 8)) 3 3 "${LEDS[$i]}"; done
  for i in 0 1 2; do r $((x + 44 + i * 12)) $((y + 5)) 10 10 "$PORTA"; done
  led $((x + 46)) $((y + 7)) 2 2 "$VERDE"; led $((x + 58)) $((y + 7)) 2 2 "$VERDE"
  porta_lateral "$x" $((y + 10))
}

firewall() { # x y
  local x=$1 y=$2 i j
  base "$x" "$y" 20
  r $((x + 2)) $((y + 2)) 4 16 "$VINHO"
  t $((x + 9)) $((y + 13)) "FW"
  for j in 0 1 2; do
    for i in 0 1 2 3; do
      r $((x + 28 + i * 10 + (j % 2) * 5)) $((y + 4 + j * 4)) 8 3 "$VINHO"
    done
  done
  led $((x + 74)) $((y + 6)) 2 2 "$VINHO"; led $((x + 78)) $((y + 6)) 2 2 "$DOURADO"
  porta_lateral "$x" $((y + 10))
}

balanceador() { # x y
  local x=$1 y=$2 i
  base "$x" "$y" 20
  r $((x + 2)) $((y + 2)) 4 16 "$AZUL"
  t $((x + 9)) $((y + 13)) "LB"
  # uma entrada que se divide em três saídas
  r $((x + 28)) $((y + 9)) 10 2 "$AZUL"
  r $((x + 38)) $((y + 4)) 2 12 "$AZUL"
  r $((x + 40)) $((y + 4)) 8 2 "$AZUL"
  r $((x + 40)) $((y + 9)) 8 2 "$AZUL"
  r $((x + 40)) $((y + 14)) 8 2 "$AZUL"
  for i in 0 1; do r $((x + 58 + i * 10)) $((y + 6)) 7 8 "$PORTA"; done
  led $((x + 60)) $((y + 7)) 2 2 "$AZUL"; led $((x + 70)) $((y + 7)) 2 2 "$VERDE"
  porta_lateral "$x" $((y + 10))
}

servidor() { # x y semente
  local x=$1 y=$2 s=$3 i
  base "$x" "$y" 44
  t $((x + 4)) $((y + 13)) "SRV"
  led $((x + 6)) $((y + 34)) 3 3 "$VERDE"
  for i in $(seq 0 3); do
    r $((x + 26 + i * 13)) $((y + 5)) 11 34 "$CEGO"
    r $((x + 28 + i * 13)) $((y + 8)) 7 1 "$PORTA"
    r $((x + 28 + i * 13)) $((y + 11)) 7 1 "$PORTA"
    led $((x + 30 + i * 13)) $((y + 33)) 3 3 "${LEDS[$(( (i * 5 + s) % 8 ))]}"
  done
  porta_lateral "$x" $((y + 22))
}

rack() { # x (borda externa esquerda), largura 160
  local x=$1 i
  r "$x" 48 160 $((Y_FIM + 4 - 48)) "$MOLDURA"
  r $((x + 4)) 52 10 $((Y_FIM - 52)) "$TRILHO"
  r $((x + 146)) 52 10 $((Y_FIM - 52)) "$TRILHO"
  for i in $(seq 0 $(( (Y_FIM - 60) / 10 ))); do
    r $((x + 7)) $((56 + i * 10)) 4 4 "$FURO"
    r $((x + 149)) $((56 + i * 10)) 4 4 "$FURO"
  done
}

# Cabos --------------------------------------------------------------------

ligar() { # x faixa0 passo k y_porta y_topo cor
  # Do equipamento ao topo do rack: sai da porta, vai à faixa k e sobe até
  # a porta que fica exatamente acima da faixa, na fileira de baixo do topo.
  # O cabo é sempre estático; o LED de atividade da porta fica na fileira
  # de cima, fora do caminho do cabo, para que só ele pisque.
  local x=$1 f0=$2 p=$3 k=$4 y=$5 ytopo=$6 cor=$7
  local fx=$((x + f0 + 1 + k * p))
  r $((fx - 1)) $((ytopo + 4)) 4 5 "$PORTA"
  led "$fx" $((ytopo + 5)) 2 2 "$cor"
  r $((fx - 1)) $((ytopo + 11)) 4 5 "$PORTA"
  r $((x + 90)) $((y - 1)) $((fx - x - 90 + 2)) 2 "$cor"
  r "$fx" $((ytopo + 12)) 2 $((y - ytopo - 11)) "$cor"
}

subir() { # x y_topo coluna cor: do topo do rack até a bandeja (uplink/tronco)
  local x=$1 y=$2 c=$3 cor=$4
  r $((x + 26 + c * 8)) $((y + 4)) 6 5 "$PORTA"
  r $((x + 27 + c * 8)) 38 3 $((y + 6 - 38)) "$cor"
}

feixe_vertical() { # x (borda esquerda de um feixe de 16px)
  local x=$1
  r $((x + 1)) 36 4 404 "$VERDE"
  r $((x + 6)) 36 4 404 "$DOURADO"
  r $((x + 11)) 36 4 404 "$AZUL"
  r $((x + 1)) 36 1 404 "$BRILHO" ; r $((x + 6)) 36 1 404 "$BRILHO" ; r $((x + 11)) 36 1 404 "$BRILHO"
  r $((x - 2)) 210 20 8 "$ABRACADEIRA"
  r $((x - 2)) 380 20 8 "$ABRACADEIRA"
}

# Monta um rack. O topo depende da topologia:
#   tor: dois ToRs, com uplink para a bandeja
#   eda: um patch panel, com tronco para a bandeja
#   hda: dois patch panels, recebendo troncos da bandeja
# Os equipamentos vêm da entrada padrão (um tipo por linha), empilhados de
# cima para baixo a partir do primeiro U livre; o total precisa dar 15U.
montar() { # x_externo topo faixa0 passo
  local xe=$1 topo=$2 f0=$3 p=$4 x=$(($1 + 14)) k=0 y tipo s=0
  local -a tops
  rack "$xe"
  case "$topo" in
    tor)
      switch "$x" "$Y0" "ToR" 0 9 2
      switch "$x" $((Y0 + U)) "ToR" 5 9 2
      subir "$x" $((Y0 + U)) 1 "$DOURADO"
      subir "$x" "$Y0" 0 "$DOURADO"
      tops=($((Y0 + U)) "$Y0"); y=$((Y0 + 2 * U)) ;;
    eda)
      patch_panel "$x" "$Y0"
      subir "$x" "$Y0" 0 "$CINZA"
      subir "$x" "$Y0" 1 "$AZUL"
      tops=("$Y0"); y=$((Y0 + U)) ;;
    hda)
      patch_panel "$x" "$Y0"
      patch_panel "$x" $((Y0 + U))
      subir "$x" $((Y0 + U)) 2 "$CINZA"
      subir "$x" $((Y0 + U)) 3 "$AZUL"
      subir "$x" "$Y0" 0 "$CINZA"
      subir "$x" "$Y0" 1 "$AZUL"
      tops=($((Y0 + U)) "$Y0"); y=$((Y0 + 2 * U)) ;;
  esac
  while read -r tipo; do
    local ytopo=${tops[$(( k % ${#tops[@]} ))]}
    s=$((s + 3))
    case "$tipo" in
      sw)  switch "$x" "$y" "SW" "$s" 7
           ligar "$x" "$f0" "$p" "$k" $((y + 10)) "$ytopo" "$VERDE"; y=$((y + U)) ;;
      rt)  roteador "$x" "$y"
           ligar "$x" "$f0" "$p" "$k" $((y + 10)) "$ytopo" "$DOURADO"; y=$((y + U)) ;;
      fw)  firewall "$x" "$y"
           ligar "$x" "$f0" "$p" "$k" $((y + 10)) "$ytopo" "$VINHO"; y=$((y + U)) ;;
      lb)  balanceador "$x" "$y"
           ligar "$x" "$f0" "$p" "$k" $((y + 10)) "$ytopo" "$AZUL"; y=$((y + U)) ;;
      srv) servidor "$x" "$y" "$s"
           ligar "$x" "$f0" "$p" "$k" $((y + 22)) "$ytopo" "$VERDE"; y=$((y + 2 * U)) ;;
    esac
    k=$((k + 1))
  done
  if (( y != Y_FIM )); then
    echo "rack em x=$xe não preenche os ${TOTAL_U}U (termina em y=$y, esperado $Y_FIM)" >&2
    exit 1
  fi
}

# Ladrilho -----------------------------------------------------------------

cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="$LARGURA_LADRILHO" height="440" viewBox="0 0 $LARGURA_LADRILHO 440" shape-rendering="crispEdges">
<!-- Fundo de datacenter em pixel art (gerado por icones/fundo/gerar-datacenter.sh, versão $1${2:+ $2}). -->
<style>
text { font: 700 8px monospace; letter-spacing: 0.5px; }
.a { animation: trafego 2s step-end infinite; }
.b { animation: trafego 4s step-end infinite; }
.c { animation: rajada 2s step-end infinite; }
.d { animation: rajada 4s step-end infinite; }
.e { animation-delay: -0.25s; }
.f { animation-delay: -1s; }
.g { animation-delay: -1.75s; }
@keyframes trafego { 0% { opacity: 1; } 25% { opacity: 0.15; } 37.5% { opacity: 1; } 75% { opacity: 0.15; } 87.5% { opacity: 1; } }
@keyframes rajada { 0% { opacity: 1; } 12.5% { opacity: 0.15; } 25% { opacity: 1; } 37.5% { opacity: 0.15; } 50% { opacity: 1; } }
@media (prefers-reduced-motion: reduce) { rect { animation: none; } }
</style>
EOF

r 0 0 "$LARGURA_LADRILHO" 440 "$FUNDO"

# bandeja de cabos no alto, contínua entre ladrilhos
r 0 0 "$LARGURA_LADRILHO" 38 "$BANDEJA"
r 0 0 "$LARGURA_LADRILHO" 2 "$MOLDURA"; r 0 36 "$LARGURA_LADRILHO" 2 "$MOLDURA"
CORES=("$VERDE" "$AZUL" "$DOURADO" "$VINHO" "$CINZA" "$AZUL")
for i in $(seq 0 5); do
  r 0 $((5 + i * 5)) "$LARGURA_LADRILHO" 4 "${CORES[$i]}"
  printf '<rect x="0" y="%s" width="%s" height="1" fill="%s" fill-opacity="%s"/>\n' \
    $((5 + i * 5)) "$LARGURA_LADRILHO" "$BRILHO" "$BRILHO_A"
done
for x in 100 300 500 700; do r "$x" 2 10 34 "$ABRACADEIRA"; done

# feixes verticais entre os racks e na emenda dos ladrilhos
for x in -8 192 392 592 792; do feixe_vertical "$x"; done

# Rack 1: ToR (2U de ToR + 1 + 1 + 1 + 5 × 2U = 15U)
montar 20 tor 100 4 <<'RACK'
rt
fw
lb
srv
srv
srv
srv
srv
RACK

# Rack 2: EDA (1U de patch panel + 7 × 2U = 15U)
montar 220 eda 100 4 <<'RACK'
srv
srv
srv
srv
srv
srv
srv
RACK

# Rack 3: HDA, só switches (2U de patch panels + 13 × 1U = 15U)
montar 420 hda 92 3 <<'RACK'
sw
sw
sw
sw
sw
sw
sw
sw
sw
sw
sw
sw
sw
RACK

# Rack 4: EDA
montar 620 eda 100 4 <<'RACK'
srv
srv
srv
srv
srv
srv
srv
RACK

echo '</svg>'
