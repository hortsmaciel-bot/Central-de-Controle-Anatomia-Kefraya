# Central de Controle Operacional — Anatomia · Grupo Kefraya

Versão autônoma (fora do Claude) deste aplicativo, pronta para publicar no Netlify — **site
fechado**: só quem tiver uma conta (criada por você) consegue entrar, tanto para ver quanto para
editar o quadro. Não existe nenhuma tela de cadastro público.

## O que tem nesta pasta

```
index.html          ← o aplicativo inteiro (HTML + CSS + JavaScript, um único arquivo)
supabase-setup.sql  ← script para criar o banco compartilhado (rodar uma vez, no Supabase)
netlify.toml        ← configuração opcional do Netlify (nenhuma é obrigatória)
README.md           ← este arquivo
```

Não existe build nem framework — é um site estático. A configuração necessária é ligar o site a
um banco gratuito (Supabase) com login, feito uma única vez (~15 minutos).

## Passo a passo — 1) criar o banco compartilhado (Supabase)

*(Se você já tinha configurado a versão anterior — com senha única da equipe — pode reaproveitar
o mesmo projeto Supabase; o script abaixo já limpa o mecanismo antigo sozinho.)*

1. Crie uma conta gratuita em [supabase.com](https://supabase.com) e clique em **"New project"**
   (sem cartão de crédito). Espere o projeto terminar de ser criado (1–2 minutos).
2. No menu lateral, abra **SQL Editor** → **New query**, cole o conteúdo do arquivo
   `supabase-setup.sql` (desta pasta) e clique em **Run**.
3. No menu lateral, abra **Project Settings** → **API**. Copie dois valores:
   - **Project URL** (algo como `https://xxxxxxxxxxxx.supabase.co`)
   - **anon public** key (uma chave longa — é pública por design, protegida pelas regras que o
     script já configurou)

## Passo a passo — 2) criar as contas da equipe (login pessoal)

1. No menu lateral, abra **Authentication → Users** → **Add user**.
2. Para cada pessoa que deve ter acesso, preencha **e-mail** e uma **senha temporária**, e marque
   **"Auto Confirm User"** (assim a pessoa já consegue entrar na hora, sem precisar confirmar
   e-mail). Repita para cada integrante da equipe.
3. Avise cada pessoa o e-mail e a senha que você definiu para ela. Não existe "esqueci minha
   senha" nesta versão — se alguém esquecer, você define uma nova para ela aqui mesmo, clicando
   no usuário → **"Reset password"**.
4. **Importante — feche o cadastro público:** vá em **Authentication → Sign In / Providers**
   (o nome exato da seção varia um pouco conforme a versão do painel do Supabase — procure por
   algo como "Allow new users to sign up" ou "Enable sign ups") e **desligue** essa opção. Sem
   isso, embora o site não tenha um formulário de cadastro, alguém tecnicamente capaz poderia
   criar uma conta própria direto pela API pública do Supabase — desligar essa chave fecha essa
   porta.

Para adicionar alguém novo à equipe depois, ou remover o acesso de alguém, é só voltar em
**Authentication → Users** e adicionar ou excluir a conta da pessoa — não precisa mexer no site
nem republicar nada no Netlify.

## Passo a passo — 3) ligar o site ao banco

1. Abra `index.html` num editor de texto e procure por (perto do topo do `<script>`):
   ```js
   const SUPABASE_URL = 'COLE_AQUI_A_URL_DO_SEU_PROJETO_SUPABASE';
   const SUPABASE_ANON_KEY = 'COLE_AQUI_A_CHAVE_ANON_PUBLICA_DO_SUPABASE';
   ```
2. Substitua pelos dois valores copiados no passo 1 (mantendo as aspas). Salve o arquivo.

## Passo a passo — 4) publicar no Netlify

**Opção mais simples — arrastar e soltar:**
1. Acesse [app.netlify.com/drop](https://app.netlify.com/drop).
2. Arraste esta pasta inteira (com o `index.html` já editado) para a área indicada.
3. Pronto — o Netlify te dá uma URL pública (`nome-aleatorio.netlify.app`) em segundos. Esse é o
   link que você compartilha com a equipe — mas sem uma conta, ninguém consegue ver nada além da
   tela de login.

**Opção via Git (se quiser deploys automáticos a cada alteração):**
1. Suba esta pasta para um repositório (GitHub, GitLab ou Bitbucket).
2. No Netlify: "Add new site" → "Import an existing project" → conecte o repositório.
3. **Build command:** deixe em branco. **Publish directory:** `.` (raiz do repositório).
4. Clique em "Deploy site".

## Como funciona o acesso

- **Ao abrir o link**, a pessoa cai direto numa tela de login (e-mail + senha) — nada do quadro é
  carregado ou aparece antes disso.
- **Sem conta**, não dá para ver nem editar nada — a conferência de quem pode ler e escrever
  acontece dentro do próprio banco (regras de segurança do Postgres), não só na tela: mesmo
  alguém tentando "conversar direto" com a API do Supabase, sem estar logado, é recusado.
- **Uma vez logada**, a pessoa fica conectada naquele navegador (não precisa entrar de novo toda
  hora) e pode ver e editar o quadro normalmente — as alterações são publicadas em tempo real
  para todo mundo que também estiver com a página aberta.
- **Sair**: menu "⋯" → "🚪 Sair" encerra a sessão naquele navegador e volta para a tela de login.
  O menu também mostra com qual e-mail a pessoa está conectada.
- **Indicador no cabeçalho**: `☁ Publicado na nuvem` (tudo certo), `⚠ Falha ao publicar`
  (problema temporário de conexão — tenta de novo sozinho) ou `⚠ Site não configurado` (os
  valores do Supabase ainda não foram preenchidos no `index.html`).

## O que funciona igual, fora do Claude

- Os quadros (kanban), os cartões, o formulário de retirada de peças, a aba de Relatórios, busca,
  tema claro/escuro.
- **Exportação em PDF** (Relatório Final de Utilização de Peças, Termo de Utilização, lista de
  retirada de peças): geração de PDF em JavaScript puro, sem depender de biblioteca nenhuma.
- **Backup/Restaurar (`.json`)**: continua funcionando — bom para uma cópia de segurança extra,
  além do banco compartilhado.

## O que continua sendo exclusivo do Claude

Só restou uma coisa que dependia do ambiente do Claude e não foi possível replicar de graça:

### Anexar arquivo diretamente do computador
No Claude, o botão "📎 Anexar arquivo do computador" enviava o arquivo para o armazenamento do
Claude. Fora dele, esse armazenamento não existe — por isso o botão vem **desativado
automaticamente** nesta versão, com um aviso ao lado. A alternativa que continua funcionando
normalmente é colar um **link** (por exemplo, do Google Drive) no campo ao lado.

*Se mais adiante vocês quiserem upload de arquivo "de verdade" aqui também, dá para adicionar
usando o mesmo Supabase (recurso de Storage, também gateado por login) — é um projeto à parte,
posso ajudar a montar quando fizer sentido.*

---

Qualquer ajuste que quiser fazer depois — cores, novos campos, nova aba — é só me pedir aqui,
como sempre. Só não esqueça de sempre me mandar a versão mais atual se você já tiver editado o
`index.html` por fora, para eu não perder nenhuma mudança sua.
