$-- Um cartão da grade de projetos; it: um item de projetos em
$-- _dados/conteudo.lua. Usado num laço: sem linha de comentário no final.
<li class="cartao projeto">
    <h2><a href="${it.url}">${it.nome}</a></h2>
    <p>${it.descricao}</p>
    <p class="tags">$for(it.tags)$<span>${it}</span>$endfor$</p>
</li>
