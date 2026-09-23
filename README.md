# Central de Controle Operacional — Anatomia · Grupo Kefraya

Versão autônoma (fora do Claude) deste aplicativo, pronta para publicar no Netlify.

## O que tem nesta pasta

```
index.html      ← o aplicativo inteiro (HTML + CSS + JavaScript, um único arquivo)
netlify.toml    ← configuração opcional do Netlify (nenhuma é obrigatória)
README.md       ← este arquivo
```

Não existe nenhuma outra dependência: não há build, não há framework (React, Vue etc.), não há
pacotes para instalar. É um site 100% estático — o mesmo tipo de arquivo que você poderia abrir
localmente dando duplo clique nele.

## Como publicar no Netlify

**Opção mais simples — arrastar e soltar:**
1. Acesse [app.netlify.com/drop](https://app.netlify.com/drop).
2. Arraste esta pasta inteira (a que contém o `index.html`) para a área indicada.
3. Pronto — o Netlify te dá uma URL pública (algo como `nome-aleatorio.netlify.app`) em segundos.

**Opção via Git (se quiser controle de versão/deploys automáticos):**
1. Suba esta pasta para um repositório (GitHub, GitLab ou Bitbucket).
2. No Netlify, clique em "Add new site" → "Import an existing project" e conecte o repositório.
3. Configurações de build:
   - **Build command:** deixe em branco (não há build).
   - **Publish directory:** `.` (a raiz do repositório — é onde está o `index.html`).
4. Clique em "Deploy site".

Não é necessário nenhum passo de build porque o projeto não usa nenhuma ferramenta de
compilação — o `index.html` já é o produto final.

## O que funciona igual, fora do Claude

Tudo o que é puramente visual e funcional continua idêntico, porque nada disso depende do
Claude:
- Os quadros (kanban), os cartões, o formulário de retirada de peças, a aba de Relatórios.
- Arrastar e soltar cartões entre colunas, busca, tema claro/escuro, o menu "⋯".
- **Exportação em PDF** (Relatório Final de Utilização de Peças, Termo de Utilização e a lista de
  retirada de peças): a geração de PDF foi escrita do zero em JavaScript puro, sem depender de
  nenhuma biblioteca externa — funciona igual dentro ou fora do Claude.
- **Salvamento automático no navegador** (localStorage): continua funcionando normalmente. Os
  dados ficam guardados no navegador de quem estiver usando o site, exatamente como já
  funcionava antes de existir o backup na nuvem.
- **Backup/Restaurar (exportar e importar um arquivo `.json`)**: também continua funcionando —
  é a forma recomendada de manter uma cópia de segurança fora do navegador nesta versão.
- A única dependência externa do arquivo é a fonte do Google Fonts (Space Grotesk / Inter),
  carregada normalmente pela internet — isso é padrão em qualquer site e não depende do Claude.

## O que é exclusivo do Claude e precisa de adaptação

Duas funcionalidades foram construídas usando recursos que só existem dentro do ambiente do
Claude (chamadas para `window.claude.use(...)`). Fora do Claude esses recursos simplesmente não
existem em lugar nenhum — não é uma questão de configuração, é que a "nuvem" que eles usavam era
a infraestrutura do próprio Claude.

### 1. Backup automático na nuvem (o que resolveu a perda de dados)
No Claude, os dados eram salvos tanto no navegador quanto em um backup privado vinculado à sua
conta Claude, o que permitia recuperar tudo mesmo se o navegador limpasse os dados locais.

**Fora do Claude, essa nuvem não existe.** Um site estático como este (Netlify puro, sem servidor
próprio) não tem onde guardar esse backup automaticamente. O aplicativo já foi construído para
lidar bem com isso: ao detectar que não está rodando dentro do Claude, ele **volta sozinho para
o modo "só neste navegador"** — sem travar, sem mostrar erro, apenas exibindo no cabeçalho o aviso
"⚠ Só neste navegador".

Para não repetir o problema da perda de dados nesta versão standalone, recomendo o hábito de
usar o botão **"Exportar backup"** (menu "⋯") periodicamente — ele baixa um `.json` com todos os
dados, que pode ser guardado no Google Drive, por exemplo, e restaurado depois com "Importar
backup" se algo acontecer com o navegador.

*Se no futuro você quiser um backup automático de verdade nesta versão (sem depender de exportar
manualmente), dá para adicionar — mas isso exige um banco de dados próprio (ex.: Supabase,
Firebase, ou uma Netlify Function com algum banco), o que é um projeto à parte de configurar uma
conta/login. Posso te ajudar com isso se quiser seguir esse caminho depois.*

### 2. Anexar arquivo diretamente do computador
No Claude, o botão "📎 Anexar arquivo do computador" enviava o arquivo para o armazenamento do
Claude e guardava o link internamente.

**Fora do Claude não existe onde guardar esse arquivo** (de novo, é um site estático, sem
servidor de armazenamento). Por isso, nesta versão o botão já vem **desativado automaticamente**,
com uma explicação visível ao lado dele. A alternativa que continua funcionando normalmente é o
campo de **link** (por exemplo, colando o link de um arquivo já salvo no seu Google Drive) — isso
não muda em nada.

*Se quiser anexos de arquivo "de verdade" nesta versão também, precisaria de um serviço de
armazenamento próprio (Netlify Blobs, Supabase Storage, Google Drive API com login, etc.) — outro
projeto à parte, e também posso ajudar a montar se fizer sentido para vocês.*

---

Qualquer ajuste que quiser fazer depois — cores, novos campos, nova aba — é só me pedir aqui,
como sempre. Só não esqueça de sempre me mandar a versão mais atual se você já tiver editado o
`index.html` por fora, para eu não perder nenhuma mudança sua.
