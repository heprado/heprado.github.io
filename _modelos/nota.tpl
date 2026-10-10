<!DOCTYPE html>
<!-- Página gerada por gerar.lua a partir de _modelos/nota.tpl e de
     _anotacoes/: não edite este .html, edite o modelo (ou a nota na vault). -->
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <title>${titulo} | Anotações | Henrique Prado</title>
        <meta name="description" content="Anotação de estudo de Henrique Prado: ${titulo} (${trilha}).">
        <meta name="author" content="Henrique Prado">
        ${cabeca()}
    </head>
    <body class="nota">
        ${controles()}

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
