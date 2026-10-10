$-- Topo de todas as páginas (partial do pandoc, usado por index.tpl e nota.tpl).
$-- base: prefixo dos links das abas ("" no index, "../index.html" nas notas).
$-- abas: a lista ABAS do gerar.lua, que gera a linha e o painel do "Mais".
<header class="topo">
    <!-- Hieróglifo nfr (F35 de Gardiner), vetorizado do PNG da wikihiero. -->
    <a class="marca" href="${base}#sobre" aria-label="heprado, início" title="heprado">
        <svg viewBox="0 0 240 760" aria-hidden="true">
            <g transform="translate(0,760) scale(0.1,-0.1)">
                <path d="M998 7163 c-4 -600 27 -555 -398 -563 -364 -7 -395 -22 -395 -200 0 -178 31 -193 395 -200 314 -6 335 -11 374 -86 29 -53 39 -2306 11 -2400 -19 -65 -50 -91 -153 -128 -109 -39 -127 -51 -186 -122 -30 -36 -84 -90 -120 -120 -36 -30 -66 -59 -66 -64 0 -5 -42 -51 -94 -103 -82 -83 -96 -101 -115 -159 -46 -140 -103 -196 -224 -222 l-27 -6 0 -979 0 -979 47 -11 c101 -25 198 -142 351 -421 40 -74 94 -161 118 -192 53 -68 83 -131 84 -175 l0 -33 605 0 605 0 0 29 c0 40 35 87 105 141 84 64 229 281 273 406 61 173 100 228 173 243 l34 7 0 978 0 979 -50 12 c-74 19 -130 84 -183 211 l-43 100 -207 211 c-216 219 -226 227 -344 269 -103 37 -134 63 -153 128 -28 94 -18 2347 11 2400 39 75 60 80 374 86 364 7 395 22 395 200 0 178 -31 193 -395 200 -425 8 -394 -37 -398 563 l-3 437 -199 0 -199 0 -3 -437z m397 -4123 c202 -20 319 -113 405 -324 24 -57 48 -95 91 -141 68 -72 80 -101 108 -257 21 -116 36 -168 91 -322 53 -149 43 -289 -35 -491 l-58 -150 -8 -145 c-12 -233 -55 -308 -169 -297 -143 13 -202 84 -221 270 -13 124 -30 159 -105 211 -35 25 -76 67 -101 103 -106 151 -274 140 -445 -30 -132 -131 -130 -128 -139 -267 -12 -186 -52 -246 -161 -238 -113 8 -164 74 -182 236 -11 90 -20 123 -55 199 -62 135 -85 505 -45 718 8 44 23 130 34 190 32 187 38 204 109 280 26 28 63 79 81 114 42 79 238 283 295 307 91 38 314 53 510 34z m-72 -1860 c32 -37 47 -107 47 -214 0 -45 7 -127 15 -182 45 -298 -27 -496 -201 -551 -146 -46 -204 64 -204 384 1 382 33 497 159 561 87 44 149 45 184 2z"/>
                <path d="M1129 2590 c-63 -11 -105 -34 -170 -94 -31 -28 -81 -73 -112 -99 -115 -98 -167 -268 -100 -327 81 -72 164 -64 248 25 111 117 243 119 368 5 67 -60 106 -80 159 -80 218 1 214 215 -10 428 -139 133 -236 169 -383 142z"/>
            </g>
        </svg>
    </a>
    <nav class="abas-nav" aria-label="Seções">
$for(abas)$
        <a href="${base}#${abas.id}" class="nav-${abas.id}">${abas.nome}</a>
$endfor$
        <button type="button" class="nav-mais" popovertarget="nav-mais-lista">Mais<span aria-hidden="true"> ▾</span></button>
        <div id="nav-mais-lista" class="nav-mais-lista" popover>
$for(abas)$
            <a href="${base}#${abas.id}" class="nav-${abas.id}">${abas.nome}</a>
$endfor$
        </div>
    </nav>
    <label for="sem-fundo" class="tema-botao fundo-botao" title="Ligar/desligar o fundo de datacenter">
        <span class="icone-fundo" aria-hidden="true">▦</span>
        <span class="fundo-texto"></span>
    </label>
    <label for="tema" class="tema-botao" title="Alternar modo claro/escuro">
        <span class="icone-sol" aria-hidden="true">☀</span>
        <span class="icone-lua" aria-hidden="true">☾</span>
        <span class="tema-texto"></span>
    </label>
</header>
$-- Esta linha fica: sem ela, o pandoc come a quebra de linha depois do partial.
