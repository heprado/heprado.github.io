-- Gera o site: o index.html e uma página por anotação, a partir dos modelos
-- do pandoc em _modelos/.
--
-- Uso (na raiz do repositório; no NixOS, dentro de `nix-shell -p pandoc`):
--
--   pandoc lua gerar.lua --gerar
--     Monta o index.html e anotacoes/*.html a partir dos modelos e das notas
--     já convertidas em _anotacoes/. Não precisa da vault: é o que se roda
--     depois de mexer no topo, no rodapé ou em qualquer modelo.
--
--   pandoc lua gerar.lua --gerar-das-notas "/caminho/da/Obsidian Vault"
--     Converte de novo as notas de T.I. da vault (tudo em Estudos/) para
--     _anotacoes/, copia as imagens usadas para anotacoes/img/ e depois faz o
--     mesmo que --gerar. Nota removida da vault some do site também.
--
-- Modelos (_modelos/): index.tpl e nota.tpl são as páginas; topo.tpl e
-- rodape.tpl são partials que as duas incluem com ${topo()} e ${rodape()}.
-- A pasta começa com "_", como _anotacoes/, e o GitHub Pages não a publica.
--
-- Atenção: a vault precisa estar com os prints sensíveis já censurados
-- (ambiente de cliente, conta AWS, abas do navegador...). O gerador publica
-- as imagens exatamente como estão.

local path = pandoc.path
local system = pandoc.system

local USO = "uso: pandoc lua gerar.lua --gerar | --gerar-das-notas <vault>"
local MODO, VAULT = arg[1], arg[2]
assert(MODO == "--gerar" or (MODO == "--gerar-das-notas" and VAULT), USO)

local SAIDA = "anotacoes"
local IMG = path.join({ SAIDA, "img" })
local DADOS = "_anotacoes"
local MODELOS = "_modelos"

-- Abas do topo, na ordem em que aparecem (a linha e o painel do "Mais").
-- Mudou nome ou ordem? Meça de novo os breakpoints do "Mais" no styles.css.
local ABAS = {
  { id = "sobre", nome = "Sobre mim" },
  { id = "experiencias", nome = "Experiências" },
  { id = "projetos", nome = "Projetos" },
  { id = "anotacoes", nome = "Anotações" },
  { id = "diversoes", nome = "Diversões" },
  { id = "pensamentos", nome = "Pensamentos" },
}

-- Pastas da vault que entram, e o nome de cada categoria na aba.
local FONTES = { "Estudos" }
local NOME_CATEGORIA = {}

-- Nota com menos que isso de texto (fora "TODO") e sem imagem fica de fora.
local MINIMO_TEXTO = 40

-- Fórmulas ($...$) só valem nas notas que têm LaTeX de verdade (potências
-- como 2^{n}); nas outras, $ é variável de shell/PHP e virava fórmula.
-- Como o Obsidian: quebra de linha simples é quebra de verdade, e tabela só
-- com "|" (os outros formatos de tabela do pandoc liam as linhas "---"
-- como início de tabela).
local FORMATO = "markdown+wikilinks_title_after_pipe+mark+hard_line_breaks"
  .. "-yaml_metadata_block-tex_math_dollars-multiline_tables-simple_tables-grid_tables"

-- O Obsidian aceita "---" e "## Título" logo abaixo de um item de lista; o
-- pandoc os grudava no item. Uma linha em branco antes resolve (fora dos
-- blocos de código).
local function separar_blocos(corpo)
  local saida, em_codigo, anterior = {}, false, ""
  for linha in (corpo .. "\n"):gmatch("(.-)\r?\n") do
    if linha:match("^%s*```") then em_codigo = not em_codigo end
    if not em_codigo and anterior:match("%S") and
       (linha:match("^%-%-%-+%s*$") or linha:match("^#+%s")) then
      saida[#saida + 1] = ""
    end
    saida[#saida + 1] = linha
    anterior = linha
  end
  return table.concat(saida, "\n")
end

local function formato(corpo)
  if corpo:find("%$[^%$\n]-%^{") then return FORMATO .. "+tex_math_dollars" end
  return FORMATO
end

-- ---------------------------------------------------------------- arquivos

local function ler(arquivo, modo)
  local f = assert(io.open(arquivo, modo or "r"))
  local conteudo = f:read("a")
  f:close()
  return conteudo
end

local function escrever(arquivo, conteudo, modo)
  local f = assert(io.open(arquivo, modo or "w"))
  f:write(conteudo)
  f:close()
end

local function eh_pasta(p)
  return (pcall(system.list_directory, p))
end

-- Apaga os arquivos de `pasta` cujo nome casa com `padrao` (cria a pasta
-- se ela não existir).
local function limpar(pasta, padrao)
  if not eh_pasta(pasta) then
    system.make_directory(pasta, true)
    return
  end
  for _, nome in ipairs(system.list_directory(pasta)) do
    if nome:match(padrao) then os.remove(path.join({ pasta, nome })) end
  end
end

-- Todos os arquivos abaixo de `pasta`, com o caminho relativo à vault.
local function varrer(pasta, rel, lista)
  for _, nome in ipairs(system.list_directory(pasta)) do
    if nome:sub(1, 1) ~= "." then
      local completo = path.join({ pasta, nome })
      local relativo = rel and path.join({ rel, nome }) or nome
      if eh_pasta(completo) then
        varrer(completo, relativo, lista)
      else
        lista[#lista + 1] = relativo
      end
    end
  end
  return lista
end

-- ------------------------------------------------------------------- nomes

local ACENTOS = {
  ["á"] = "a", ["à"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a",
  ["é"] = "e", ["ê"] = "e", ["è"] = "e", ["í"] = "i", ["ì"] = "i",
  ["ó"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o", ["ú"] = "u",
  ["ü"] = "u", ["ç"] = "c", ["ñ"] = "n",
}

local function sem_acento(s)
  s = pandoc.text.lower(s)
  for de, para in pairs(ACENTOS) do s = s:gsub(de, para) end
  return s
end

local function slug(s)
  return (sem_acento(s):gsub("[^%w]+", "-"):gsub("^%-+", ""):gsub("%-+$", ""))
end

local function escapar(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- ---------------------------------------------------------- frontmatter

-- Separa o frontmatter YAML do corpo. O YAML das notas é simples (title,
-- created, tags), então basta ler essas chaves linha a linha.
local function separar(texto)
  local meta = { tags = {} }
  local yaml, corpo = texto:match("^%-%-%-\r?\n(.-)\r?\n%-%-%-\r?\n?(.*)$")
  if not yaml then return meta, texto end
  local em_tags = false
  for linha in (yaml .. "\n"):gmatch("(.-)\r?\n") do
    local chave, valor = linha:match("^([%w_-]+):%s*(.-)%s*$")
    if chave then
      em_tags = chave == "tags"
      valor = valor:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
      if chave == "title" or chave == "created" then meta[chave] = valor end
    elseif em_tags then
      local tag = linha:match("^%s*%-%s*(.-)%s*$")
      if tag then
        tag = tag:gsub('^"(.*)"$', "%1"):gsub("^#", "")
        if tag ~= "" then meta.tags[#meta.tags + 1] = tag end
      end
    end
  end
  return meta, corpo
end

local function relevante(corpo)
  if corpo:find("!%[") then return true end
  local texto = corpo:gsub("//%s*TODO", ""):gsub("%s+", " ")
  return #texto >= MINIMO_TEXTO
end

-- ------------------------------------------------------------------ vault

-- Lê e converte as notas da vault: cada nota sai com o corpo já em HTML, e
-- as imagens usadas são copiadas para anotacoes/img/.
local function ler_vault(vault)
  local arquivos = varrer(vault, nil, {})

  -- Imagens da vault pelo nome do arquivo (o Obsidian as referencia assim).
  local imagens = {}
  for _, rel in ipairs(arquivos) do
    local nome = path.filename(rel)
    local base, ext = path.split_extension(nome)
    if ext:lower():match("^%.(png)$") or ext:lower():match("^%.(jpe?g)$") or ext:lower():match("^%.(gif)$") then
      imagens[nome] = { origem = path.join({ vault, rel }), saida = slug(base) .. ext:lower() }
    end
  end

  local notas, por_titulo = {}, {}
  for _, rel in ipairs(arquivos) do
    local partes = path.split(rel)
    local dentro = false
    for _, fonte in ipairs(FONTES) do dentro = dentro or partes[1] == fonte end
    if dentro and rel:match("%.md$") and not rel:match("%.excalidraw%.md$") then
      local meta, corpo = separar(ler(path.join({ vault, rel })))
      if relevante(corpo) then
        local arquivo = path.split_extension(path.filename(rel))
        local nota = {
          rel = rel,
          arquivo = arquivo,
          titulo = meta.title or arquivo,
          criado = meta.created and meta.created:match("^(%d%d%d%d%-%d%d%-%d%d)"),
          tags = meta.tags,
          corpo = corpo,
          slug = slug(path.split_extension(rel):gsub("^Estudos/", "")),
        }
        -- Categoria: a pasta logo abaixo de Estudos/ (ou a própria fonte);
        -- grupo: as subpastas que sobram até a nota.
        if partes[1] == "Estudos" then
          nota.categoria = #partes > 2 and partes[2] or "Outros"
          nota.grupo = table.concat({ table.unpack(partes, 3, #partes - 1) }, " / ")
        else
          nota.categoria = NOME_CATEGORIA[partes[1]] or partes[1]
          nota.grupo = table.concat({ table.unpack(partes, 2, #partes - 1) }, " / ")
        end
        notas[#notas + 1] = nota
      end
    end
  end

  -- Endereços repetidos (ex.: "Nota.md" e "Nota .md", com espaço) ganham um
  -- número, senão uma página sobrescreveria a outra. A ordem é a do caminho,
  -- para o número não mudar de uma geração para outra.
  table.sort(notas, function(a, b) return a.rel < b.rel end)
  local slugs = {}
  for _, n in ipairs(notas) do
    local base, i = n.slug, 2
    while slugs[n.slug] do n.slug = base .. "-" .. i; i = i + 1 end
    slugs[n.slug] = true
  end

  -- Títulos repetidos ganham o nome do arquivo para se diferenciar.
  local contagem = {}
  for _, n in ipairs(notas) do contagem[n.titulo] = (contagem[n.titulo] or 0) + 1 end
  for _, n in ipairs(notas) do
    if contagem[n.titulo] > 1 then n.titulo = n.titulo .. " — " .. n.arquivo end
  end

  -- Wikilinks apontam pelo nome do arquivo ou pelo título.
  for _, n in ipairs(notas) do
    por_titulo[sem_acento(n.arquivo)] = n
    por_titulo[sem_acento(n.titulo)] = por_titulo[sem_acento(n.titulo)] or n
  end

  -- Links externos que perderam o conteúdo (veja anotacoes/links-rot.txt).
  local ROT = {}
  for linha in (ler(path.join({ SAIDA, "links-rot.txt" })) .. "\n"):gmatch("(.-)\r?\n") do
    linha = linha:match("^%s*(.-)%s*$")
    if linha ~= "" and not linha:match("^#") then ROT[linha] = true end
  end

  local usadas = {}

  local function imagem(alvo)
    local info = imagens[path.filename(alvo)]
    if not info then return nil end
    usadas[info.saida] = info.origem
    return "img/" .. info.saida
  end

  local filtro = {
    -- ![[x.png]] e ![texto](x.png): aponta para anotacoes/img/.
    Image = function(el)
      local novo = imagem(el.src)
      if not novo then
        io.stderr:write("aviso: imagem não encontrada: " .. el.src .. "\n")
        return {}
      end
      -- Texto alternativo automático ("image1", nome do arquivo) não descreve
      -- nada; melhor vazio.
      local alt = pandoc.utils.stringify(el.caption)
      if alt:match("^image%d*$") or alt:match("%.%a%a%a%a?$") then el.caption = {} end
      el.src = novo
      el.attr.classes = {}
      el.attributes.loading = "lazy"
      return el
    end,

    -- Imagem sozinha num parágrafo vira figura com legenda. Os textos
    -- automáticos ("image1", vindos do OneNote, ou o nome do arquivo) não são
    -- legenda: aí fica só a imagem.
    Figure = function(el)
      local legenda = pandoc.utils.stringify(el.caption.long)
      if legenda == "" or legenda:match("^image%d*$") or legenda:match("%.%a%a%a%a?$") then
        return el.content
      end
    end,

    -- [[Nota]]: link para a página dela; sem página, fica só o texto.
    -- Links externos mortos (links-rot.txt) ganham " (ROT)" depois; os
    -- censurados (com █ no endereço) e os do OneNote (apontam pro OneDrive
    -- da empresa) não levam a lugar nenhum e viram texto.
    Link = function(el)
      if not el.classes:includes("wikilink") then
        if el.target:find("█") or el.target:match("^onenote:") then return pandoc.Span(el.content) end
        if ROT[el.target] then return { el, pandoc.Str(" (ROT)") } end
        return nil
      end
      local alvo = por_titulo[sem_acento((el.target:gsub("#.*$", "")))]
      if not alvo then return pandoc.Span(el.content) end
      el.target = alvo.slug .. ".html"
      el.attr.classes = {}
      el.title = ""
      return el
    end,

    -- Os títulos da nota descem um nível: o h1 da página é o título dela.
    Header = function(el)
      el.level = math.min(el.level + 1, 6)
      return el
    end,

    -- Callouts do Obsidian: "> [!NOTE] Título".
    BlockQuote = function(el)
      local primeiro = el.content[1]
      if not primeiro or primeiro.t ~= "Para" then return nil end
      local tipo = pandoc.utils.stringify(primeiro.content[1] or ""):match("^%[!(%w+)%]")
      if not tipo then return nil end
      local resto = pandoc.List({ table.unpack(primeiro.content, 2) })
      local titulo, corpo = pandoc.List(), pandoc.List()
      local alvo = titulo
      for _, inl in ipairs(resto) do
        if inl.t == "SoftBreak" or inl.t == "LineBreak" then
          if alvo == titulo then alvo = corpo else alvo:insert(inl) end
        else
          alvo:insert(inl)
        end
      end
      while titulo[1] and titulo[1].t == "Space" do titulo:remove(1) end
      local blocos = pandoc.List()
      blocos:insert(pandoc.Para({ pandoc.Strong(#titulo > 0 and titulo or { pandoc.Str(tipo) }) }))
      if #corpo > 0 then blocos:insert(pandoc.Para(corpo)) end
      blocos:extend({ table.unpack(el.content, 2) })
      return pandoc.Div(blocos, { class = "callout callout-" .. tipo:lower() })
    end,
  }

  for _, n in ipairs(notas) do
    local corpo = separar_blocos(n.corpo)
    local doc = pandoc.read(corpo, formato(corpo)):walk(filtro)
    n.corpo = pandoc.write(doc, "html", { html_math_method = "mathml" })
  end

  -- Imagens: só as usadas, e as de antes saem (nota removida leva as dela).
  limpar(IMG, ".")
  local n_img = 0
  for saida, origem in pairs(usadas) do
    escrever(path.join({ IMG, saida }), ler(origem, "rb"), "wb")
    n_img = n_img + 1
  end
  print(("%d imagens copiadas da vault"):format(n_img))
  return notas
end

-- ------------------------------------------------------- notas convertidas

-- _anotacoes/: o corpo de cada nota em <slug>.html e os dados dela (título,
-- categoria, grupo, data, tags) numa linha de notas.jsonl, em ordem de slug
-- para o diff ficar legível.
local INDICE = path.join({ DADOS, "notas.jsonl" })
local CAMPOS = { "slug", "titulo", "categoria", "grupo", "criado", "tags" }

local function salvar_notas(notas)
  limpar(DADOS, ".")
  table.sort(notas, function(a, b) return a.slug < b.slug end)
  local linhas = {}
  for _, n in ipairs(notas) do
    escrever(path.join({ DADOS, n.slug .. ".html" }), n.corpo)
    local campos = {}
    for _, c in ipairs(CAMPOS) do
      local v = n[c]
      if c == "tags" and v and #v == 0 then v = nil end
      if v ~= nil then campos[#campos + 1] = pandoc.json.encode(c) .. ":" .. pandoc.json.encode(v) end
    end
    linhas[#linhas + 1] = "{" .. table.concat(campos, ",") .. "}"
  end
  escrever(INDICE, table.concat(linhas, "\n") .. "\n")
end

local function carregar_notas()
  local notas = {}
  for linha in ler(INDICE):gmatch("[^\n]+") do
    local n = pandoc.json.decode(linha, false)
    n.corpo = ler(path.join({ DADOS, n.slug .. ".html" }))
    notas[#notas + 1] = n
  end
  return notas
end

-- ------------------------------------------------------------------ páginas

local function modelo(nome)
  local arquivo = path.join({ MODELOS, nome .. ".tpl" })
  return pandoc.template.compile(ler(arquivo), arquivo)
end

local function aplicar(tpl, contexto)
  return pandoc.layout.render(pandoc.template.apply(tpl, contexto))
end

local function data_br(iso)
  if not iso then return nil end
  local a, m, d = iso:match("(%d+)%-(%d+)%-(%d+)")
  return d .. "/" .. m .. "/" .. a
end

local function ordem(a, b) return sem_acento(a) < sem_acento(b) end

-- A lista da aba Anotações: uma caixa por categoria, com os grupos dentro.
local function lista_anotacoes(notas)
  local categorias, por_categoria = {}, {}
  for _, n in ipairs(notas) do
    if not por_categoria[n.categoria] then
      por_categoria[n.categoria] = {}
      categorias[#categorias + 1] = n.categoria
    end
    local grupos = por_categoria[n.categoria]
    grupos[n.grupo] = grupos[n.grupo] or {}
    table.insert(grupos[n.grupo], n)
  end
  table.sort(categorias, ordem)

  local I = "                    "
  local linhas = {}
  local function l(s) linhas[#linhas + 1] = s end

  for _, cat in ipairs(categorias) do
    local grupos, nomes, total = por_categoria[cat], {}, 0
    for g, lista in pairs(grupos) do nomes[#nomes + 1] = g; total = total + #lista end
    table.sort(nomes, ordem)
    l(I .. '<details class="cartao anotacoes-categoria">')
    l(I .. '    <summary><h2>' .. escapar(cat) .. '</h2><span class="contagem">' .. total .. '</span></summary>')
    for _, g in ipairs(nomes) do
      local lista = grupos[g]
      table.sort(lista, function(a, b) return ordem(a.titulo, b.titulo) end)
      if g ~= "" then l(I .. '    <h3>' .. escapar(g) .. '</h3>') end
      l(I .. '    <ul>')
      for _, n in ipairs(lista) do
        l(I .. '        <li><a href="anotacoes/' .. n.slug .. '.html">' .. escapar(n.titulo) .. '</a></li>')
      end
      l(I .. '    </ul>')
    end
    l(I .. '</details>')
  end
  return table.concat(linhas, "\n"), #categorias
end

local function montar_site(notas)
  local nota = modelo("nota")
  limpar(SAIDA, "%.html$")
  for _, n in ipairs(notas) do
    escrever(path.join({ SAIDA, n.slug .. ".html" }), aplicar(nota, {
      base = "../index.html",
      abas = ABAS,
      titulo = n.titulo,
      trilha = n.categoria .. (n.grupo ~= "" and (" / " .. n.grupo) or ""),
      criado = n.criado,
      ["criado-br"] = data_br(n.criado),
      tags = n.tags,
      body = n.corpo,
    }))
  end

  local lista, n_categorias = lista_anotacoes(notas)
  escrever("index.html", aplicar(modelo("index"), {
    base = "",
    abas = ABAS,
    anotacoes = lista,
  }))
  print(("%d notas, %d categorias"):format(#notas, n_categorias))
end

-- -------------------------------------------------------------------- main

if MODO == "--gerar-das-notas" then
  salvar_notas(ler_vault(VAULT))
end
montar_site(carregar_notas())
