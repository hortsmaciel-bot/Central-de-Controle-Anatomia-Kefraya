# Central de Controle Operacional — Anatomia · Grupo Kefraya

Versão autônoma (fora do Claude) deste aplicativo, pronta para publicar no Netlify — **com quadro
compartilhado na nuvem**: qualquer pessoa com o link vê o mesmo quadro em tempo real, e só quem
tiver a senha da equipe consegue editar.

## O que tem nesta pasta

```
index.html          ← o aplicativo inteiro (HTML + CSS + JavaScript, um único arquivo)
supabase-setup.sql  ← script para criar o banco compartilhado (rodar uma vez, no Supabase)
netlify.toml        ← configuração opcional do Netlify (nenhuma é obrigatória)
README.md           ← este arquivo
```

Não existe build nem framework — é um site estático. A única configuração necessária é ligar o
site a um banco de dados gratuito (Supabase), em ~10 minutos, feito uma única vez. Sem isso, o
app ainda funciona, só que cada navegador guarda os dados sozinho (era o comportamento da versão
anterior).

## Passo a passo — 1) criar o banco compartilhado (Supabase)

1. Crie uma conta gratuita em [supabase.com](https://supabase.com) e clique em **"New project"**.
   Não pede cartão de crédito. Escolha um nome (ex.: `kefraya-anatomia`) e uma senha de banco
   (guarde-a, mas ela não é a senha da equipe — são coisas diferentes).
2. Espere o projeto terminar de ser criado (1–2 minutos).
3. No menu lateral, abra **SQL Editor** → **New query**.
4. Abra o arquivo `supabase-setup.sql` (desta pasta), troque o texto `TROQUE-ESTA-SENHA` pela
   senha que a equipe vai usar para editar o quadro, copie o script inteiro e cole no editor do
   Supabase. Clique em **Run**.
5. No menu lateral, abra **Project Settings** → **API**. Copie dois valores:
   - **Project URL** (algo como `https://xxxxxxxxxxxx.supabase.co`)
   - **anon public** key (uma chave longa — é pública por design, protegida pelas regras que o
     script já configurou; não é a senha da equipe nem a senha do banco)

## Passo a passo — 2) ligar o site ao banco

1. Abra `index.html` num editor de texto e procure por (perto do topo do `<script>`):
   ```js
   const SUPABASE_URL = 'COLE_AQUI_A_URL_DO_SEU_PROJETO_SUPABASE';
   const SUPABASE_ANON_KEY = 'COLE_AQUI_A_CHAVE_ANON_PUBLICA_DO_SUPABASE';
   ```
2. Substitua pelos dois valores copiados no passo anterior (mantendo as aspas). Salve o arquivo.

## Passo a passo — 3) publicar no Netlify

**Opção mais simples — arrastar e soltar:**
1. Acesse [app.netlify.com/drop](https://app.netlify.com/drop).
2. Arraste esta pasta inteira (com o `index.html` já editado) para a área indicada.
3. Pronto — o Netlify te dá uma URL pública (`nome-aleatorio.netlify.app`) em segundos. Esse é o
   link que pode ser compartilhado com qualquer pessoa.

**Opção via Git (se quiser deploys automáticos a cada alteração):**
1. Suba esta pasta para um repositório (GitHub, GitLab ou Bitbucket).
2. No Netlify: "Add new site" → "Import an existing project" → conecte o repositório.
3. **Build command:** deixe em branco. **Publish directory:** `.` (raiz do repositório).
4. Clique em "Deploy site".

Sempre que quiser trocar a senha da equipe depois, não precisa mexer no site nem no Netlify — só
rodar de novo o pequeno trecho no final do `supabase-setup.sql` no SQL Editor do Supabase, com a
senha nova.

## Como funciona o compartilhamento

- **Ver o quadro:** qualquer pessoa com o link já vê os dados reais, sem precisar de senha nem
  login — a leitura é pública.
- **Editar o quadro:** ao tentar editar (ou clicando no indicador no canto superior direito do
  cabeçalho), a pessoa precisa digitar a **senha da equipe**. Uma vez desbloqueado, aquele
  navegador fica lembrado (não precisa digitar de novo toda hora) e todas as alterações passam a
  ser publicadas para todo mundo, em tempo real.
- **Sem a senha:** a pessoa continua vendo o quadro normalmente. Se mexer em algo mesmo assim, a
  alteração fica salva só naquele navegador (nada é perdido), mas **não é publicada** para os
  outros até alguém desbloquear com a senha correta.
- **Indicador no cabeçalho:** mostra o estado atual — `☁ Publicado na nuvem` (tudo certo e
  publicado), `🔒 Somente leitura` (aguardando a senha), `⚠ Só neste navegador` (banco ainda não
  configurado, veja os passos acima) ou `⚠ Falha ao publicar` (problema temporário de conexão —
  ele tenta de novo sozinho). Clicar no indicador abre a tela de desbloqueio, ou oferece bloquear
  de novo se já estiver desbloqueado.
- A senha nunca fica visível em lugar nenhum acessível: a conferência acontece dentro do próprio
  banco de dados (Supabase), então mesmo alguém abrindo o código-fonte da página não consegue
  descobrir a senha nem editar sem ela.

## O que funciona igual, fora do Claude

- Os quadros (kanban), os cartões, o formulário de retirada de peças, a aba de Relatórios, busca,
  tema claro/escuro, o menu "⋯".
- **Exportação em PDF** (Relatório Final de Utilização de Peças, Termo de Utilização, lista de
  retirada de peças): geração de PDF em JavaScript puro, sem depender de biblioteca nenhuma.
- **Backup/Restaurar (`.json`)**: continua funcionando — bom para uma cópia de segurança extra,
  além do banco compartilhado.
- Dependências externas do arquivo: a fonte do Google Fonts e a biblioteca do Supabase (carregada
  de um CDN público) — ambas padrão em qualquer site, nada exclusivo do Claude.

## O que continua sendo exclusivo do Claude

Só restou uma coisa que depende do ambiente do Claude e não foi possível replicar de graça nesta
versão:

### Anexar arquivo diretamente do computador
No Claude, o botão "📎 Anexar arquivo do computador" enviava o arquivo para o armazenamento do
Claude. Fora dele, esse armazenamento não existe — por isso o botão vem **desativado
automaticamente** nesta versão, com um aviso ao lado. A alternativa que continua funcionando
normalmente é colar um **link** (por exemplo, do Google Drive) no campo ao lado.

*Se mais adiante vocês quiserem upload de arquivo "de verdade" aqui também, dá para adicionar
usando o mesmo Supabase (recurso de Storage) — é um projeto à parte, posso ajudar a montar quando
fizer sentido.*

---

Qualquer ajuste que quiser fazer depois — cores, novos campos, nova aba — é só me pedir aqui,
como sempre. Só não esqueça de sempre me mandar a versão mais atual se você já tiver editado o
`index.html` por fora, para eu não perder nenhuma mudança sua.
