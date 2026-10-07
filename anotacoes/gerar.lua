-- Gera a aba Anotações a partir da vault do Obsidian.
--
-- Uso (na raiz do repositório):
--   pandoc lua anotacoes/gerar.lua "/caminho/da/Obsidian Vault"
-- No NixOS:
--   nix-shell -p pandoc --run 'pandoc lua anotacoes/gerar.lua "/caminho/da/Obsidian Vault"'
--
-- Lê só as notas de T.I., tudo em Estudos/. Cada nota vira
-- anotacoes/<slug>.html (modelo em
-- anotacoes/modelo.tpl), as imagens usadas são copiadas sem conversão para
-- anotacoes/img/, e a lista da aba é reescrita no index.html, entre os
-- marcadores ANOTACOES:INICIO e ANOTACOES:FIM. As páginas antigas são
-- apagadas antes, para nota removida da vault sumir do site também.
--
-- Atenção: a vault precisa estar com os prints sensíveis já censurados
-- (ambiente de cliente, conta AWS, abas do navegador...). O gerador publica
-- as imagens exatamente como estão.

local path = pandoc.path
local system = pandoc.system

local VAULT = arg[1] or error("uso: pandoc lua anotacoes/gerar.lua <vault>")
local SAIDA = "anotacoes"
local IMG = path.join({ SAIDA, "img" })

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

-- -------------------------------------------------------------- inventário

local arquivos = varrer(VAULT, nil, {})

-- Imagens da vault pelo nome do arquivo (o Obsidian as referencia assim).
local imagens = {}
for _, rel in ipairs(arquivos) do
  local nome = path.filename(rel)
  local base, ext = path.split_extension(nome)
  if ext:lower():match("^%.(png)$") or ext:lower():match("^%.(jpe?g)$") or ext:lower():match("^%.(gif)$") then
    imagens[nome] = { origem = path.join({ VAULT, rel }), saida = slug(base) .. ext:lower() }
  end
end

local notas, por_titulo = {}, {}
for _, rel in ipairs(arquivos) do
  local partes = path.split(rel)
  local dentro = false
  for _, fonte in ipairs(FONTES) do dentro = dentro or partes[1] == fonte end
  if dentro and rel:match("%.md$") and not rel:match("%.excalidraw%.md$") then
    local meta, corpo = separar(ler(path.join({ VAULT, rel })))
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

-- Títulos repetidos ganham o nome
-- do arquivo para se diferenciar.
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

-- ------------------------------------------------------------ conversão

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
  Link = function(el)
    if not el.classes:includes("wikilink") then return nil end
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

-- ------------------------------------------------------------- páginas

-- Limpa as páginas e imagens geradas antes (nada além de *.html e img/).
for _, nome in ipairs(system.list_directory(SAIDA)) do
  if nome:match("%.html$") then os.remove(path.join({ SAIDA, nome })) end
end
if eh_pasta(IMG) then
  for _, nome in ipairs(system.list_directory(IMG)) do os.remove(path.join({ IMG, nome })) end
else
  system.make_directory(IMG, true)
end

local modelo = pandoc.template.compile(ler(path.join({ SAIDA, "modelo.tpl" })))

local function data_br(iso)
  if not iso then return nil end
  local a, m, d = iso:match("(%d+)%-(%d+)%-(%d+)")
  return d .. "/" .. m .. "/" .. a
end

for _, n in ipairs(notas) do
  local corpo = separar_blocos(n.corpo)
  local doc = pandoc.read(corpo, formato(corpo)):walk(filtro)
  local trilha = n.categoria .. (n.grupo ~= "" and (" / " .. n.grupo) or "")
  local html = pandoc.write(doc, "html", {
    template = modelo,
    html_math_method = "mathml",
    variables = {
      titulo = n.titulo,
      trilha = trilha,
      criado = n.criado,
      ["criado-br"] = data_br(n.criado),
      tags = n.tags,
    },
  })
  escrever(path.join({ SAIDA, n.slug .. ".html" }), html)
end

for saida, origem in pairs(usadas) do
  escrever(path.join({ IMG, saida }), ler(origem, "rb"), "wb")
end

-- ------------------------------------------------------- lista na aba

local function ordem(a, b) return sem_acento(a) < sem_acento(b) end

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

local index = ler("index.html")
local antes, depois = index:match("^(.-<!%-%- ANOTACOES:INICIO %-%->).-(\n[ ]*<!%-%- ANOTACOES:FIM %-%->.*)$")
assert(antes, "marcadores ANOTACOES:INICIO/FIM não encontrados no index.html")
escrever("index.html", antes .. "\n" .. table.concat(linhas, "\n") .. depois)

local n_img = 0
for _ in pairs(usadas) do n_img = n_img + 1 end
print(("%d notas, %d imagens, %d categorias"):format(#notas, n_img, #categorias))
