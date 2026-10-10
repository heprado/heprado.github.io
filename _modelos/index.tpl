<!DOCTYPE html>
<!-- Página gerada por gerar.lua a partir de _modelos/index.tpl: não edite
     este .html, edite o modelo e rode `pandoc lua gerar.lua --gerar`. -->
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <title>Henrique Prado | Técnico de Redes de Computadores</title>
        <meta name="description" content="Henrique Prado, técnico de redes de computadores em São Paulo. Mais de 6 anos em datacenter, redes, nuvem (AWS, Azure, GCP) e desenvolvimento em C#, Python e TypeScript.">
        <meta name="author" content="Henrique Prado">
        ${cabeca()}
        <link rel="canonical" href="https://heprado.com.br/">

        <!-- Prévia ao compartilhar o link (Open Graph e X) -->
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://heprado.com.br/">
        <meta property="og:site_name" content="Henrique Prado">
        <meta property="og:locale" content="pt_BR">
        <meta property="og:title" content="Henrique Prado | Técnico de Redes de Computadores">
        <meta property="og:description" content="Mais de 6 anos em datacenter, redes, nuvem e desenvolvimento de software. Experiências, projetos e algumas diversões.">
        <meta property="og:image" content="https://heprado.com.br/icones/og-image.png">
        <meta property="og:image:width" content="1200">
        <meta property="og:image:height" content="630">
        <meta property="og:image:alt" content="Hieróglifo nfr ao lado do nome Henrique Prado">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:creator" content="@hepraga">

        <!-- Dados estruturados para buscadores (não é JavaScript executável) -->
        <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "Person",
            "name": "Henrique Prado",
            "url": "https://heprado.com.br/",
            "image": "https://heprado.com.br/icones/og-image.png",
            "jobTitle": "Técnico de Redes de Computadores",
            "address": {
                "@type": "PostalAddress",
                "addressLocality": "São Paulo",
                "addressRegion": "SP",
                "addressCountry": "BR"
            },
            "alumniOf": "FIAP – Faculdade de Informática e Administração Paulista",
            "knowsAbout": ["Datacenter", "Redes de computadores", "Cisco ACI", "AWS", "Azure", "GCP", "Terraform", "C#", "Python", "TypeScript"],
            "sameAs": [
                "https://github.com/heprado",
                "https://linkedin.com/in/heprado",
                "https://x.com/hepraga",
                "https://www.last.fm/user/tidebinder"
            ]
        }
        </script>
    </head>
    <body>
        ${controles()}

        <!-- Cena do parallax: o fundo de datacenter fica numa camada atrás,
             rolando na metade da velocidade do conteúdo (só CSS). -->
        <div class="cena">
        <div class="fundo" aria-hidden="true"></div>
        <div class="pagina">
            ${topo()}

            <main class="abas">
                <!-- SOBRE MIM -->
                <section id="sobre" class="aba">
                    <h1>Sobre mim</h1>
                    <div class="cartao">
                        <!-- TODO(Henrique): escrever o texto do "Sobre mim" aqui. -->
                        <p class="rascunho">Em breve.</p>
                    </div>
                </section>

                <!-- EXPERIÊNCIAS -->
                <section id="experiencias" class="aba">
                    <h1>Experiências</h1>
                    <p class="resumo">Mais de 6 anos de experiência em datacenter, nuvem e desenvolvimento de software. Experiência em provas de conceito de redes de datacenter e nuvem. Une domínio técnico em redes, AWS/Azure/GCP e Terraform com desenvolvimento em C#, Python e TypeScript, além de apresentações técnicas a clientes e parceiros.</p>
                    <ol class="linha-tempo">
$for(experiencias)$
                        ${experiencias:experiencia()}
$endfor$
                    </ol>

                    <div class="grade-extras">
                        <div class="cartao">
                            <h2>Formação Acadêmica</h2>
                            <p>Bacharelado em Redes de Computadores</p>
                            <p class="empresa">FIAP – Faculdade de Informática e Administração Paulista</p>
                            <p class="empresa">Conclusão: 2021</p>
                        </div>
                        <div class="cartao">
                            <h2>Certificações</h2>
                            <ul>
                                <li>CCNA Routing and Switching (expirada)</li>
                            </ul>
                        </div>
                        <div class="cartao">
                            <h2>Idiomas</h2>
                            <ul>
                                <li>Inglês – Intermediário (conversação e escrita)</li>
                            </ul>
                        </div>
                    </div>
                </section>

                <!-- PROJETOS -->
                <section id="projetos" class="aba">
                    <h1>Projetos</h1>
                    <ul class="grade-projetos">
$for(projetos)$
                        ${projetos:projeto()}
$endfor$
                    </ul>
                    <p class="mais"><a href="https://github.com/heprado?tab=repositories">Todos os repositórios no GitHub →</a></p>
                </section>

                <!-- DIVERSÕES -->
                <section id="diversoes" class="aba">
                    <h1>Diversões</h1>
                    <div class="cartao">
                        <h2>Entidades rodopiantes</h2>
                        <div class="formas">
                            <div id="piramide">
                                <img id="piramide_norte" src="./icones/piramide/piramide_norte.svg" alt="">
                                <img id="piramide_sul" src="./icones/piramide/piramide_sul.svg" alt="">
                                <img id="piramide_leste" src="./icones/piramide/piramide_leste.svg" alt="">
                                <img id="piramide_oeste" src="./icones/piramide/piramide_oeste.svg" alt="">
                            </div>
                            <div id="cubo">
                                <img id="cubo_frente" src="./icones/cubo/cubo_frente.svg" alt="">
                                <img id="cubo_costas" src="./icones/cubo/cubo_costas.svg" alt="">
                                <img id="cubo_topo" src="./icones/cubo/cubo_topo.svg" alt="">
                                <img id="cubo_fundo" src="./icones/cubo/cubo_fundo.svg" alt="">
                                <img id="cubo_esquerda" src="./icones/cubo/cubo_esquerda.svg" alt="">
                                <img id="cubo_direita" src="./icones/cubo/cubo_direita.svg" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="cartao">
                        <h2>Jogos</h2>
                        <p><a href="./WebEssentials/index.html">WebEssentials →</a></p>
                    </div>
                </section>

                <!-- ANOTAÇÕES: a lista sai das notas em _anotacoes/ (gerar.lua). -->
                <section id="anotacoes" class="aba">
                    <h1>Anotações</h1>
                    <p class="resumo">Minhas anotações de estudo, tiradas do Obsidian: redes, nuvem, automação, programação e o que mais apareceu pelo caminho. São notas de quem estava aprendendo, então podem ter erros.</p>
$-- A lista já vem indentada do gerar.lua; por isso a variável fica na coluna 0.
${anotacoes}
                </section>

                <!-- PENSAMENTOS (antiga texto.html) -->
                <section id="pensamentos" class="aba">
                    <h1>Pensamentos</h1>
$for(pensamentos)$
                    ${pensamentos:pensamento()}
$endfor$
                </section>
            </main>

            ${rodape()}
        </div>
        </div>
    </body>
</html>
