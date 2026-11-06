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

## Personalizando as abas do menu (sem precisar de código)

Agora dá para adicionar, editar, reordenar ou remover as abas de quadro do cabeçalho (as que
mostram "ITC Belo Horizonte", "Transportes" etc.) direto pelo site, sem editar nenhum arquivo:

1. Clique no menu **"⋯"** (canto superior direito) → **"⚙️ Gerenciar abas do menu"**.
2. Nessa janela dá para:
   - **Adicionar** uma aba nova ("+ Adicionar aba") — escolha um ícone (emoji), o nome, os nomes
     das duas colunas do quadro (ex.: "Em andamento" / "Concluídas") e se os cartões daquela aba
     têm prazo (sem data, uma data só, ou um período com início e fim).
   - **Editar** uma aba existente (nome, ícone, nomes das colunas, tipo de prazo).
   - **Reordenar** com as setinhas ▲▼ — a ordem ali é a mesma ordem das abas no cabeçalho.
   - **Remover** uma aba — pede confirmação, porque apaga também todos os cartões daquela aba.
3. As alterações ficam salvas na hora (no navegador e, se o site estiver configurado com o banco
   compartilhado, também publicadas na nuvem para toda a equipe).

As abas **"Visão geral"**, **"To Do's"** e **"Relatórios"** são fixas e não
aparecem nessa lista — elas têm uma função própria no site (painel-resumo, organização de eventos
e geração de PDFs), diferente de um quadro comum.

**Importante:** essa personalização não exige nenhum passo extra no GitHub, no Supabase ou no
Netlify. As abas ficam guardadas junto com o resto dos dados do quadro (o mesmo lugar onde já
ficam os cartões), então continuam funcionando normalmente com a configuração que você já tem —
só é preciso atualizar o arquivo `index.html` (ver "Passo a passo — 3" e a seção seguinte) para
que o botão "⚙️ Gerenciar abas do menu" apareça no site.

## O que funciona igual, fora do Claude

- Os quadros (kanban), os cartões, a aba de To Do's, a aba de Relatórios, busca,
  tema claro/escuro.
- **Exportação em PDF** (Relatório Final de Utilização de Peças, Termo de Utilização, Tempos e
  Movimentos de um evento/curso, Protocolo de Transporte, lista de retirada de peças): geração de
  PDF em JavaScript puro, sem depender de biblioteca nenhuma — inclusive as imagens (logo e
  certificados) são embutidas diretamente, sem nenhum serviço externo. O de Tempos e Movimentos
  sai numa página só (formato paisagem) — se o cronograma for enorme, com dezenas de linhas de
  texto longo, ele usa uma fonte menor automaticamente e, apenas nesse caso raro, continua numa 2ª
  página, para nunca cortar informação.
- **Backup/Restaurar (`.json`)**: continua funcionando — bom para uma cópia de segurança extra,
  além do banco compartilhado.

## Novo tipo de relatório: Tempos e Movimentos

Na aba **Relatórios**, além do "Relatório Final de Utilização" e do "Termo de Utilização", agora
existe também **"⏱️ Tempos e Movimentos"** — para planejar e registrar o cronograma de um evento
ou curso (horário de início/fim de cada atividade, duração calculada automaticamente, equipe
responsável, local e observações). Dá pra usar a coluna "Dia" quando o evento tiver mais de um
dia. O PDF gerado sai sempre numa página só, em formato paisagem.

A primeira coluna da tabela, **"Cor"**, deixa marcar visualmente linhas-chave do cronograma —
início operacional, pausas de alimentação, organização final, ou qualquer outro ponto que você
queira destacar. É só clicar numa das bolinhas de cor da linha (ou no "✕" para remover a cor); a
mesma cor escolhida aparece também no PDF exportado, igual ao que se vê na tela.

**Importante:** essa funcionalidade não exige nenhuma alteração no Supabase, no GitHub ou no
Netlify — os dados desses relatórios ficam guardados junto com o resto do quadro (o mesmo banco
que você já configurou). Só é preciso publicar esta versão atualizada do `index.html`.

## Aba "✅ To Do's" — gestão dos seus projetos

A antiga aba "Planejamento de Eventos" foi substituída por uma lista de tarefas organizada por
projeto (os dados antigos de eventos foram descartados, a pedido).

- **Novo projeto:** escreva o nome no topo, escolha a prioridade (alta, média, baixa) e aperte
  Enter. Cada projeto vira um cartão com cor da prioridade, **prazo**, barra de progresso e um
  campo de **notas**.
- **Tarefas:** dentro do projeto, escreva a tarefa e aperte Enter. Marque a caixinha quando
  fizer (fica riscada). Cada tarefa tem sua própria **prioridade** (clique na etiqueta para
  alternar alta → média → baixa) e **prazo** — prazos vencidos ficam em vermelho.
- **Ordenar projetos:** por prioridade (padrão), prazo, mais recentes, nome ou **manual** (setas
  ▲ ▼). Projetos concluídos vão para o fim automaticamente.
- **Ordenar tarefas:** setas ▲ ▼ em cada tarefa, ou o botão "⇅ Ordenar tarefas por prioridade".
- **Filtros:** Todos / Em andamento / Concluídos, e "Ocultar tarefas concluídas". O número na
  aba mostra quantas tarefas ainda estão abertas.
- Dá para recolher um projeto (▾), limpar as tarefas concluídas ou excluir o projeto inteiro.

**Importante:** isso não exige nenhuma alteração no Supabase, no GitHub ou no Netlify — os
projetos ficam guardados junto com o resto do quadro (o mesmo banco que você já configurou). Só é
preciso publicar esta versão atualizada do `index.html`.

## Novo tipo de relatório: Protocolo de Transporte

Na aba **Relatórios**, agora existe também **"🚑 Protocolo de Transporte"** — gera o PDF de 5
páginas (capa do protocolo, lista de transporte, declaração de conformidade, Anexo I — certificado
de acreditação AATB, Anexo II — carta de acompanhamento AATB) no mesmo molde do documento modelo
que você enviou, com todo o texto fixo (parágrafos de conformidade, declaração, assinaturas,
cabeçalho/rodapé, as duas imagens do anexo AATB) exatamente igual em todo PDF gerado.

Como funciona:

- **Campos editáveis** (equivalentes ao que estava destacado em amarelo no documento modelo):
  unidade (campo livre — digite só o nome, ex.: "BH" ou "Recife"; o "ITC" entra sozinho — e as
  unidades já usadas ficam salvas como botões para escolher com 1 clique, com "✕" para remover da
  lista), CNPJ, datas de emissão e da declaração, pessoa de contato, a **rota do transporte**
  (etapas com data e endereço) e a **lista de transporte** (tipo de material e os códigos de
  identificação — um por linha; a quantidade é contada sozinha a partir de quantos códigos você
  digitar).
- **Numeração do transporte** (o que estava em vermelho no documento modelo): é um número que **só
  avança sozinho, em ordem crescente**, no exato momento em que você clica em "Gerar PDF" pela
  primeira vez para aquele transporte. O formulário sempre mostra, antes de gerar, qual vai ser o
  próximo número. Baixar de novo um protocolo do histórico **não** consome um número novo — ele
  reaproveita o número já emitido daquele transporte. Já o botão "↺ Carregar" (que traz os dados de
  um protocolo antigo de volta ao formulário, como ponto de partida para um transporte novo) limpa
  o número, para que o próximo "Gerar PDF" emita um número novo, e não repita o anterior.
- **Visual do PDF:** os campos que mudam a cada transporte e o código saem em **preto** (ou **branco**
  quando o fundo é verde-escuro). **Todos os PDFs do app** (este, Utilização, Termo e Tempos e
  Movimentos) usam a mesma fonte, embutida no próprio arquivo — então aparece igual em qualquer
  computador ou celular. A fonte usada hoje é a *Instrument Sans* (gratuita), parecida com a
  Avenir; a Avenir original é licenciada e o arquivo dela precisaria ser fornecido.
- O histórico de protocolos já emitidos fica logo abaixo do formulário, com opção de carregar como
  modelo, baixar de novo ou excluir.

**Importante:** essa funcionalidade também não exige nenhuma alteração no Supabase, no GitHub ou
no Netlify — os protocolos e o contador da numeração ficam guardados junto com o resto do quadro
(o mesmo banco que você já configurou). Só é preciso publicar esta versão atualizada do
`index.html`.

## Novidades em Relatórios: assinatura, técnico local e Ações Semanais

**Assinatura digitalizada.** O *Relatório Final de Utilização* e o *Termo de Utilização* agora saem com a
sua assinatura (sem fundo, em tamanho pequeno e proporcional) sobre a linha de assinatura. Em cada um
desses dois formulários há a opção **"Incluir minha assinatura digitalizada no PDF"** — desmarque quando
outra pessoa for assinar. A assinatura também aparece no relatório de Ações Semanais.

**Termo de Utilização — técnico(a) de laboratório local.** O PDF ganhou um segundo bloco de assinatura,
em branco, com linha para nome legível/unidade e data — cada unidade preenche o nome do seu técnico
no próprio papel e ele assina in loco.

**🗓️ Ações Semanais do Técnico** (novo tipo, em Relatórios). Um relatório por unidade e por semana:
- **Cursos**: um cartão por curso (nome, data, horário, coordenação) com a lista de peças destinadas a ele
  e o **dia de descongelamento** de cada peça. Atalho: informe "descongelar N dias antes do curso" e clique
  em *Preencher datas vazias* (não altera datas que você já escolheu).
- Cursos que duram mais de um dia: informe o **"Último dia"** — o curso aparece em cada dia no calendário ("Dia 1 de 3") e o período sai no cabeçalho do curso.
- **Dias bloqueados**: marque dias (ou períodos) em que a unidade não pode receber atividades — obras, manutenção,
  feriado. Aparecem em cinza no calendário (com o motivo) e numa seção própria do PDF. Se houver curso, ação ou
  descongelamento num dia bloqueado, o app avisa antes de gerar o PDF.
- **Ações extra lab**: ação, data, horário, **que horas o transporte chega**, local, **peças a levar**
  (uma por linha), observações e o **descongelamento** das peças da ação (data e horário, ou "dias antes da ação" + Calcular data) — marcado no calendário.
- O PDF abre com um **calendário da semana** (dia a dia, com os cursos, as ações extra lab e os dias de
  descongelamento marcados por cor) e depois traz os detalhes: os cursos (com o dia de descongelamento de cada peça), as ações extra lab, observações gerais e
  somente a sua assinatura.
- Fica salvo no histórico (Carregar / Baixar de novo / Excluir), igual aos outros relatórios.

Nada muda no Supabase, no Netlify nem no GitHub: os dados novos são guardados no mesmo registro que o app já usa.

## Anexar arquivos do computador

O botão **"📎 Anexar arquivo do computador"**, dentro de cada cartão, envia o arquivo para um
espaço de armazenamento privado no seu próprio Supabase (recurso chamado *Storage*), no mesmo
projeto onde já fica o quadro — não depende de nada do Claude.

- **Continua fechado:** só quem tem login consegue enviar, ver ou baixar os arquivos anexados —
  a mesma regra que já protege o resto do quadro.
- **Limite de 20 MB** por arquivo.
- Ao clicar em "↗" para abrir um anexo, o site pede ao Supabase um link válido só por 60 segundos
  — por isso não existe um link fixo e permanente para cada arquivo (mais seguro: mesmo que
  alguém veja esse link, ele expira rapidinho).
- Colar um **link** (por exemplo, do Google Drive), no campo ao lado, continua funcionando
  normalmente — é útil para arquivos que já estão salvos em outro lugar.

Isso já vem configurado no `supabase-setup.sql` desta pasta (passo 6 do script, seção "Espaço de
anexos"). Se você configurou o banco compartilhado **antes** dessa funcionalidade existir, basta
rodar o `supabase-setup.sql` atualizado de novo no SQL Editor do seu projeto — o script inteiro é
seguro para rodar mais de uma vez (ele não apaga nada que já existe, só garante que o espaço de
anexos e as regras dele estejam corretos).

---

Qualquer ajuste que quiser fazer depois — cores, novos campos, nova aba — é só me pedir aqui,
como sempre. Só não esqueça de sempre me mandar a versão mais atual se você já tiver editado o
`index.html` por fora, para eu não perder nenhuma mudança sua.
