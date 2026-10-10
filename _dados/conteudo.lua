-- Conteúdo das listas do index.html, lido pelo gerar.lua. Cada item vira um
-- cartão pelo modelo de mesmo nome em _modelos/ (experiencia.tpl,
-- projeto.tpl, pensamento.tpl). Os textos entram como HTML, do jeito que
-- estão: dá para usar <br>, <a>, <strong>..., e um "&" solto se escreve "&amp;".
--
-- Depois de mexer aqui: pandoc lua gerar.lua --gerar
return {
  -- Experiências, da mais recente para a mais antiga.
  -- periodo, cargo, empresa: texto; itens: um <li> cada; tags: rótulos.
  experiencias = {
    {
      periodo = "Nov/2025 — Out/2026",
      cargo = "Desenvolvedor e Arquiteto de Software",
      empresa = "FCamara | São Paulo, SP",
      itens = {
        "Desenvolvimento de APIs RESTful em C# com arquitetura serverless na AWS (Lambda, DynamoDB, SQS, SNS, S3).",
        "Provisionamento de nova infraestrutura como código com CloudFormation, gestão de permissões com IAM e criação de pipelines de CI/CD no Azure DevOps.",
        "Administração e tuning de banco Aurora PostgreSQL.",
        "Desenvolvimento de dashboards de monitoramento em tempo real com React.",
      },
      tags = { "C#", "APIs RESTful", "Serverless", "AWS", "Lambda", "DynamoDB", "SQS", "SNS", "S3", "Infraestrutura como código", "CloudFormation", "IAM", "CI/CD", "Azure DevOps", "Aurora PostgreSQL", "Tuning de banco", "React", "Dashboards", "Monitoramento em tempo real" },
    },
    {
      periodo = "Jan/2024 — Out/2025",
      cargo = "Desenvolvedor e Arquiteto de Software",
      empresa = "SONDA Tecnologia | São Paulo, SP",
      itens = {
        "Arquitetura e desenvolvimento de plataforma de DCIM (gestão de infraestrutura de datacenter) para um grande banco público federal, com Angular, C# e SQL Server, hospedada em IIS.",
        "Integração de soluções de monitoramento, automação e governança em ambientes híbridos.",
      },
      tags = { "Arquitetura de software", "DCIM", "Angular", "C#", "SQL Server", "IIS", "Monitoramento", "Automação", "Governança", "Ambientes híbridos" },
    },
    {
      periodo = "Jan/2022 — Dez/2023",
      cargo = "Engenheiro de TI Especialista",
      empresa = "F1RST Digital Services | São Paulo, SP",
      itens = {
        "Gerenciamento de servidores Linux e Windows em ambientes on-premises e em nuvem (AWS e Azure).",
        "Centralização e análise de logs e métricas com ELK Stack (Elasticsearch, Logstash, Kibana), Splunk, rsyslog e Grafana.",
        "Automação de processos de datacenter com Python e PHP, integrada a plataformas de auto-delivery.",
      },
      tags = { "Linux", "Windows", "On-premises", "AWS", "Azure", "ELK Stack", "Elasticsearch", "Logstash", "Kibana", "Splunk", "rsyslog", "Grafana", "Logs e métricas", "Python", "PHP", "Automação de datacenter", "Auto-delivery" },
    },
    {
      periodo = "Jan/2021 — Dez/2021",
      cargo = "Engenheiro de Redes",
      empresa = "Cisco do Brasil | São Paulo, SP",
      itens = {
        "Provas de conceito de redes de datacenter com ACI, VXLAN/MP-BGP EVPN, FabricPath, vPC (Virtual Port Channel), Private VLAN e SAN.",
        "Provas de conceito de virtualização e containers com VMware vCenter, OpenShift e Kubernetes, em nuvens híbridas (AWS, Azure, GCP, OCI).",
        "Apresentações técnicas a clientes e parceiros e desenvolvimento de scripts de automação com Python e Terraform.",
      },
      tags = { "Cisco ACI", "ACI Multi-Site", "Provas de conceito", "VXLAN", "MP-BGP EVPN", "FabricPath", "vPC", "Private VLAN", "SAN", "Virtualização", "Containers", "VMware vCenter", "OpenShift", "Kubernetes", "Nuvem híbrida", "AWS", "Azure", "GCP", "OCI", "Python", "Terraform", "Apresentações técnicas" },
    },
    {
      periodo = "Jan/2019 — Dez/2020",
      cargo = "Estágio em Engenharia de Redes",
      empresa = "Cisco do Brasil | São Paulo, SP",
      itens = {
        "Organização do laboratório de redes e apoio na importação de equipamentos para provas de conceito e preparação para certificação CCNA Routing and Switching.",
      },
      tags = { "Laboratório de redes", "Importação de equipamentos", "Provas de conceito", "CCNA Routing and Switching" },
    },
  },

  -- Projetos, na ordem da grade.
  -- nome, url: o título e o link; descricao: um parágrafo; tags: rótulos.
  projetos = {
    {
      nome = "nexos",
      url = "https://github.com/heprado/nexos",
      descricao = "Configurações NixOS declarativas, separadas por máquina e por usuário. Hyprland, Noctalia e uma paleta de cores única (a da Tama) aplicada em todos os apps.",
      tags = { "Nix", "NixOS", "Hyprland" },
    },
    {
      nome = "noctalia-monitor-settings",
      url = "https://github.com/heprado/noctalia-monitor-settings",
      descricao = "Plugin do Noctalia para configurar monitores: arranjo das telas arrastando no canvas, resolução, taxa de atualização, escala e controle DDC/CI completo via ddcutil.",
      tags = { "QML", "Quickshell", "Wayland" },
    },
    {
      nome = "asus-b150m-pro-gaming-ptt-enabler",
      url = "https://github.com/heprado/asus-b150m-pro-gaming-ptt-enabler",
      descricao = "Habilita o Intel PTT (TPM 2.0) na placa-mãe ASUS B150M Pro Gaming, liberando o Windows 11 sem precisar de um módulo TPM dedicado.",
      tags = { "Python", "BIOS", "Firmware" },
    },
    {
      nome = "LUNA",
      url = "https://github.com/heprado/LUNA",
      descricao = "Local Unique Network Advisor.",
      tags = { "C#", "Redes" },
    },
    {
      nome = "advent-of-code-2024-rust",
      url = "https://github.com/heprado/advent-of-code-2024-rust",
      descricao = "Minhas soluções para os problemas do Advent of Code 2024.",
      tags = { "Rust" },
    },
    {
      nome = "htmx-pokedex",
      url = "https://github.com/heprado/htmx-pokedex",
      descricao = "Uma Pokédex feita com htmx.",
      tags = { "htmx", "CSS" },
    },
    {
      nome = "tama-shell",
      url = "https://github.com/heprado/tama-shell",
      descricao = "Shell de desktop em Quickshell (QML/Qt). Por enquanto só o ambiente de desenvolvimento, com Nix e devenv.",
      tags = { "QML", "Nix", "em andamento" },
    },
  },

  -- Pensamentos, do mais recente para o mais antigo.
  -- data: AAAA-MM-DD (vira DD/MM/AAAA na página); titulo; texto: um parágrafo.
  pensamentos = {
    {
      data = "2025-06-30",
      titulo = "Confusão",
      texto = "Gosto de ficar sozinho mas não 80% do meu tempo aqui.",
    },
    {
      data = "2025-06-13",
      titulo = "Sentir",
      texto = [[Desde que me inseri no mercado de trabalho, eu só trabalhei com computadores,
no início era um rack com alguns servidores,switches e um firewall que fazia roteamento de tudo,
porque mesmo o switch tendo SVI ninguem sabia usar, eu no momento trabalho com data centers
e não sei se isso é mais correto, como um humano. Eu não acho que as aplicações que estão sendo
criadas e as que estão sendo somente mantidas estão ajudando a humanidade. Talvez seja a hora de parar.
Bom, um dia eu ainda vou adicionar outras entidades rodopiantes, só não hoje que eu estou mal (quando que não né Henrique).]],
    },
    {
      data = "2025-04-04",
      titulo = "Com TI",
      texto = [[- Você trabalha com oquê?<br>
- Com TI.<br>
- Comigo?<br>
- Ahn?<br>
- Nunca te vi lá no meu trabalho.]],
    },
    {
      data = "2025-03-31",
      titulo = "Convívio social",
      texto = "Algumas pessoas só querem ser gentis com as outras e isso não tem nada a ver com amor.",
    },
    {
      data = "2025-03-21",
      titulo = "Início",
      texto = "Vou começar a usar isso aqui pra jogar pensamentos.",
    },
  },
}
