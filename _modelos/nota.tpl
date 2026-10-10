<!DOCTYPE html>
<!-- Página gerada por gerar.lua a partir de _modelos/nota.tpl e de
     _anotacoes/: não edite este .html, edite o modelo (ou a nota na vault). -->
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <title>${titulo} | Anotações | Henrique Prado</title>
        <meta name="description" content="Anotação de estudo de Henrique Prado: ${titulo} (${trilha}).">
        <meta name="author" content="Henrique Prado">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="color-scheme" content="light dark">
        <meta name="theme-color" content="#EAEAEA" media="(prefers-color-scheme: light)">
        <meta name="theme-color" content="#171A21" media="(prefers-color-scheme: dark)">
        <link rel="icon" href="../icones/nefer.svg" type="image/svg+xml">
        <link rel="icon" href="../icones/favicon-32.png" type="image/png" sizes="32x32">
        <link rel="apple-touch-icon" href="../icones/apple-touch-icon.png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap">
        <link rel="stylesheet" href="../styles.css">
    </head>
    <body class="nota">
        <!-- Botão de tema: o checkbox inverte o modo do sistema (CSS :has). -->
        <input type="checkbox" id="tema" class="tema-input" aria-label="Alternar modo claro/escuro">
        <!-- Botão de fundo: o checkbox inverte o padrão (ligado, ou desligado
             para quem pede menos movimento no sistema). -->
        <input type="checkbox" id="sem-fundo" class="tema-input" aria-label="Ligar/desligar o fundo de datacenter">

        <!-- Cena do parallax: o fundo de datacenter fica numa camada atrás,
             rolando na metade da velocidade do conteúdo (só CSS). -->
        <div class="cena">
        <div class="fundo" aria-hidden="true"></div>
        <div class="pagina">
            ${topo()}

            <main class="abas">
                <article class="nota-conteudo">
                    <p class="trilha"><a href="../index.html#anotacoes">Anotações</a> / ${trilha}</p>
                    <h1>${titulo}</h1>
$if(criado)$
                    <p class="periodo"><time datetime="${criado}">${criado-br}</time></p>
$endif$
$if(tags)$
                    <p class="tags">$for(tags)$<span>${tags}</span>$endfor$</p>
$endif$
                    <div class="cartao nota-corpo">
${body}
                    </div>
                    <p class="mais"><a href="../index.html#anotacoes">← Todas as anotações</a></p>
                </article>
            </main>

            ${rodape()}
        </div>
        </div>
    </body>
</html>
