<!DOCTYPE html>
<!-- Página gerada por gerar.lua a partir de _modelos/index.tpl: não edite
     este .html, edite o modelo e rode `pandoc lua gerar.lua --gerar`. -->
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <title>Henrique Prado | Técnico de Redes de Computadores</title>
        <meta name="description" content="Henrique Prado, técnico de redes de computadores em São Paulo. Mais de 6 anos em datacenter, redes, nuvem (AWS, Azure, GCP) e desenvolvimento em C#, Python e TypeScript.">
        <meta name="author" content="Henrique Prado">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="color-scheme" content="light dark">
        <meta name="theme-color" content="#EAEAEA" media="(prefers-color-scheme: light)">
        <meta name="theme-color" content="#171A21" media="(prefers-color-scheme: dark)">
        <link rel="canonical" href="https://heprado.com.br/">

        <!-- Favicon -->
        <link rel="icon" href="icones/nefer.svg" type="image/svg+xml">
        <link rel="icon" href="icones/favicon-32.png" type="image/png" sizes="32x32">
        <link rel="apple-touch-icon" href="icones/apple-touch-icon.png">

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
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap">
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
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
                        <li class="cartao">
                            <p class="periodo">Nov/2025 — Out/2026</p>
                            <h2>Desenvolvedor e Arquiteto de Software</h2>
                            <p class="empresa">FCamara | São Paulo, SP</p>
                            <ul>
                                <li>Desenvolvimento de APIs RESTful em C# com arquitetura serverless na AWS (Lambda, DynamoDB, SQS, SNS, S3).</li>
                                <li>Provisionamento de nova infraestrutura como código com CloudFormation, gestão de permissões com IAM e criação de pipelines de CI/CD no Azure DevOps.</li>
                                <li>Administração e tuning de banco Aurora PostgreSQL.</li>
                                <li>Desenvolvimento de dashboards de monitoramento em tempo real com React.</li>
                            </ul>
                            <p class="tags"><span>C#</span><span>APIs RESTful</span><span>Serverless</span><span>AWS</span><span>Lambda</span><span>DynamoDB</span><span>SQS</span><span>SNS</span><span>S3</span><span>Infraestrutura como código</span><span>CloudFormation</span><span>IAM</span><span>CI/CD</span><span>Azure DevOps</span><span>Aurora PostgreSQL</span><span>Tuning de banco</span><span>React</span><span>Dashboards</span><span>Monitoramento em tempo real</span></p>
                        </li>
                        <li class="cartao">
                            <p class="periodo">Jan/2024 — Out/2025</p>
                            <h2>Desenvolvedor e Arquiteto de Software</h2>
                            <p class="empresa">SONDA Tecnologia | São Paulo, SP</p>
                            <ul>
                                <li>Arquitetura e desenvolvimento de plataforma de DCIM (gestão de infraestrutura de datacenter) para um grande banco público federal, com Angular, C# e SQL Server, hospedada em IIS.</li>
                                <li>Integração de soluções de monitoramento, automação e governança em ambientes híbridos.</li>
                            </ul>
                            <p class="tags"><span>Arquitetura de software</span><span>DCIM</span><span>Angular</span><span>C#</span><span>SQL Server</span><span>IIS</span><span>Monitoramento</span><span>Automação</span><span>Governança</span><span>Ambientes híbridos</span></p>
                        </li>
                        <li class="cartao">
                            <p class="periodo">Jan/2022 — Dez/2023</p>
                            <h2>Engenheiro de TI Especialista</h2>
                            <p class="empresa">F1RST Digital Services | São Paulo, SP</p>
                            <ul>
                                <li>Gerenciamento de servidores Linux e Windows em ambientes on-premises e em nuvem (AWS e Azure).</li>
                                <li>Centralização e análise de logs e métricas com ELK Stack (Elasticsearch, Logstash, Kibana), Splunk, rsyslog e Grafana.</li>
                                <li>Automação de processos de datacenter com Python e PHP, integrada a plataformas de auto-delivery.</li>
                            </ul>
                            <p class="tags"><span>Linux</span><span>Windows</span><span>On-premises</span><span>AWS</span><span>Azure</span><span>ELK Stack</span><span>Elasticsearch</span><span>Logstash</span><span>Kibana</span><span>Splunk</span><span>rsyslog</span><span>Grafana</span><span>Logs e métricas</span><span>Python</span><span>PHP</span><span>Automação de datacenter</span><span>Auto-delivery</span></p>
                        </li>
                        <li class="cartao">
                            <p class="periodo">Jan/2021 — Dez/2021</p>
                            <h2>Engenheiro de Redes</h2>
                            <p class="empresa">Cisco do Brasil | São Paulo, SP</p>
                            <ul>
                                <li>Provas de conceito de redes de datacenter com ACI, VXLAN/MP-BGP EVPN, FabricPath, vPC (Virtual Port Channel), Private VLAN e SAN.</li>
                                <li>Provas de conceito de virtualização e containers com VMware vCenter, OpenShift e Kubernetes, em nuvens híbridas (AWS, Azure, GCP, OCI).</li>
                                <li>Apresentações técnicas a clientes e parceiros e desenvolvimento de scripts de automação com Python e Terraform.</li>
                            </ul>
                            <p class="tags"><span>Cisco ACI</span><span>ACI Multi-Site</span><span>Provas de conceito</span><span>VXLAN</span><span>MP-BGP EVPN</span><span>FabricPath</span><span>vPC</span><span>Private VLAN</span><span>SAN</span><span>Virtualização</span><span>Containers</span><span>VMware vCenter</span><span>OpenShift</span><span>Kubernetes</span><span>Nuvem híbrida</span><span>AWS</span><span>Azure</span><span>GCP</span><span>OCI</span><span>Python</span><span>Terraform</span><span>Apresentações técnicas</span></p>
                        </li>
                        <li class="cartao">
                            <p class="periodo">Jan/2019 — Dez/2020</p>
                            <h2>Estágio em Engenharia de Redes</h2>
                            <p class="empresa">Cisco do Brasil | São Paulo, SP</p>
                            <ul>
                                <li>Organização do laboratório de redes e apoio na importação de equipamentos para provas de conceito e preparação para certificação CCNA Routing and Switching.</li>
                            </ul>
                            <p class="tags"><span>Laboratório de redes</span><span>Importação de equipamentos</span><span>Provas de conceito</span><span>CCNA Routing and Switching</span></p>
                        </li>
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
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/nexos">nexos</a></h2>
                            <p>Configurações NixOS declarativas, separadas por máquina e por usuário. Hyprland, Noctalia e uma paleta de cores única (a da Tama) aplicada em todos os apps.</p>
                            <p class="tags"><span>Nix</span><span>NixOS</span><span>Hyprland</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/noctalia-monitor-settings">noctalia-monitor-settings</a></h2>
                            <p>Plugin do Noctalia para configurar monitores: arranjo das telas arrastando no canvas, resolução, taxa de atualização, escala e controle DDC/CI completo via ddcutil.</p>
                            <p class="tags"><span>QML</span><span>Quickshell</span><span>Wayland</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/asus-b150m-pro-gaming-ptt-enabler">asus-b150m-pro-gaming-ptt-enabler</a></h2>
                            <p>Habilita o Intel PTT (TPM 2.0) na placa-mãe ASUS B150M Pro Gaming, liberando o Windows 11 sem precisar de um módulo TPM dedicado.</p>
                            <p class="tags"><span>Python</span><span>BIOS</span><span>Firmware</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/LUNA">LUNA</a></h2>
                            <p>Local Unique Network Advisor.</p>
                            <p class="tags"><span>C#</span><span>Redes</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/advent-of-code-2024-rust">advent-of-code-2024-rust</a></h2>
                            <p>Minhas soluções para os problemas do Advent of Code 2024.</p>
                            <p class="tags"><span>Rust</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/htmx-pokedex">htmx-pokedex</a></h2>
                            <p>Uma Pokédex feita com htmx.</p>
                            <p class="tags"><span>htmx</span><span>CSS</span></p>
                        </li>
                        <li class="cartao projeto">
                            <h2><a href="https://github.com/heprado/tama-shell">tama-shell</a></h2>
                            <p>Shell de desktop em Quickshell (QML/Qt). Por enquanto só o ambiente de desenvolvimento, com Nix e devenv.</p>
                            <p class="tags"><span>QML</span><span>Nix</span><span>em andamento</span></p>
                        </li>
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
                    <article class="cartao pensamento">
                        <p class="periodo"><time datetime="2025-06-30">30/06/2025</time></p>
                        <h2>Confusão</h2>
                        <p>Gosto de ficar sozinho mas não 80% do meu tempo aqui.</p>
                    </article>
                    <article class="cartao pensamento">
                        <p class="periodo"><time datetime="2025-06-13">13/06/2025</time></p>
                        <h2>Sentir</h2>
                        <p>Desde que me inseri no mercado de trabalho, eu só trabalhei com computadores,
                        no início era um rack com alguns servidores,switches e um firewall que fazia roteamento de tudo,
                        porque mesmo o switch tendo SVI ninguem sabia usar, eu no momento trabalho com data centers
                        e não sei se isso é mais correto, como um humano. Eu não acho que as aplicações que estão sendo
                        criadas e as que estão sendo somente mantidas estão ajudando a humanidade. Talvez seja a hora de parar.
                        Bom, um dia eu ainda vou adicionar outras entidades rodopiantes, só não hoje que eu estou mal (quando que não né Henrique).</p>
                    </article>
                    <article class="cartao pensamento">
                        <p class="periodo"><time datetime="2025-04-04">04/04/2025</time></p>
                        <h2>Com TI</h2>
                        <p>- Você trabalha com oquê?<br>
                        - Com TI.<br>
                        - Comigo?<br>
                        - Ahn?<br>
                        - Nunca te vi lá no meu trabalho.</p>
                    </article>
                    <article class="cartao pensamento">
                        <p class="periodo"><time datetime="2025-03-31">31/03/2025</time></p>
                        <h2>Convívio social</h2>
                        <p>Algumas pessoas só querem ser gentis com as outras e isso não tem nada a ver com amor.</p>
                    </article>
                    <article class="cartao pensamento">
                        <p class="periodo"><time datetime="2025-03-21">21/03/2025</time></p>
                        <h2>Início</h2>
                        <p>Vou começar a usar isso aqui pra jogar pensamentos.</p>
                    </article>
                </section>
            </main>

            ${rodape()}
        </div>
        </div>
    </body>
</html>
