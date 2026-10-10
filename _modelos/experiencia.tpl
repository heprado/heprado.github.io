$-- Um cartão da linha do tempo (aba Experiências); it: um item de
$-- experiencias em _dados/conteudo.lua. Usado num laço, então termina sem a
$-- linha de comentário final que os partials avulsos (topo, rodapé) têm.
<li class="cartao">
    <p class="periodo">${it.periodo}</p>
    <h2>${it.cargo}</h2>
    <p class="empresa">${it.empresa}</p>
    <ul>
$for(it.itens)$
        <li>${it}</li>
$endfor$
    </ul>
    <p class="tags">$for(it.tags)$<span>${it}</span>$endfor$</p>
</li>
