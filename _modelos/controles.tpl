$-- Os checkboxes que ligam o tema e o fundo (partial avulso). Ficam antes da
$-- .cena porque o CSS os acha por id (#tema, #sem-fundo) e pelo ~ irmão.
<!-- Botão de tema: o checkbox inverte o modo do sistema (CSS :has). -->
<input type="checkbox" id="tema" class="tema-input" aria-label="Alternar modo claro/escuro">
<!-- Botão de fundo: o checkbox inverte o padrão (ligado, ou desligado
     para quem pede menos movimento no sistema). -->
<input type="checkbox" id="sem-fundo" class="tema-input" aria-label="Ligar/desligar o fundo de datacenter">
$-- Esta linha fica: sem ela, o pandoc come a quebra de linha depois do partial.
