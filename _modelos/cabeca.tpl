$-- Parte do <head> comum a todas as páginas (partial avulso): tela, cores do
$-- tema, ícones, fonte e CSS. raiz: prefixo dos arquivos ("" no index,
$-- "../" nas notas).
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="light dark">
<meta name="theme-color" content="#EAEAEA" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#171A21" media="(prefers-color-scheme: dark)">
<link rel="icon" href="${raiz}icones/nefer.svg" type="image/svg+xml">
<link rel="icon" href="${raiz}icones/favicon-32.png" type="image/png" sizes="32x32">
<link rel="apple-touch-icon" href="${raiz}icones/apple-touch-icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap">
<link rel="stylesheet" href="${raiz}styles.css">
$-- Esta linha fica: sem ela, o pandoc come a quebra de linha depois do partial.
