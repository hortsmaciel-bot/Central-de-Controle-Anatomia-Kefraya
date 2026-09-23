-- =========================================================
-- Central de Controle Operacional — Anatomia · Grupo Kefraya
-- Script de configuração do banco compartilhado (Supabase)
-- Versão com LOGIN PESSOAL (Supabase Auth) — site fechado:
-- só quem tem conta consegue ver ou editar o quadro.
-- =========================================================
-- Cole este script inteiro no SQL Editor do seu projeto Supabase
-- (menu lateral "SQL Editor" → "New query") e clique em "Run".
-- Depois disso, siga o README.md para criar as contas da equipe e
-- desativar o cadastro público (passos que ficam no painel, fora do SQL).

-- 1) Tabela com o estado inteiro do quadro (um único registro/linha)
create table if not exists board_state (
  id text primary key default 'kefraya-anatomia',
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into board_state (id, data)
values ('kefraya-anatomia', '{}'::jsonb)
on conflict (id) do nothing;

alter table board_state enable row level security;

-- 2) Limpa qualquer política antiga de leitura pública (versão anterior, sem login)
drop policy if exists "Qualquer pessoa pode ler o quadro" on board_state;

-- 3) Só quem está logado (qualquer conta criada pelo coordenador) pode ler e editar
drop policy if exists "Só quem está logado pode ler o quadro" on board_state;
create policy "Só quem está logado pode ler o quadro"
  on board_state for select
  using (auth.role() = 'authenticated');

drop policy if exists "Só quem está logado pode editar o quadro" on board_state;
create policy "Só quem está logado pode editar o quadro"
  on board_state for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

grant select, update on board_state to authenticated;
revoke all on board_state from anon;
-- (a partir daqui, visitantes sem login (papel "anon") não enxergam nada)

-- 4) Ativar atualização ao vivo (Realtime) nesta tabela — assim, quando
--    alguém publica uma alteração, todo mundo logado vê na hora.
--    (Se já rodou isso na versão anterior, pode ignorar um eventual erro
--    de "already member of publication" — significa que já está ativo.)
alter publication supabase_realtime add table board_state;

-- 5) Limpeza: remove o mecanismo antigo de "senha única da equipe",
--    que foi substituído por login pessoal de cada um
drop function if exists update_board_state(jsonb, text);
drop function if exists verify_password(text);
drop table if exists app_secrets;

-- =========================================================
-- Depois de rodar este script, vá para o painel do Supabase e:
--
-- 1) Authentication → Users → "Add user" — crie uma conta (e-mail + senha)
--    para cada pessoa da equipe que deve ter acesso. Marque
--    "Auto Confirm User" para a pessoa já poder entrar imediatamente.
--
-- 2) Authentication → Sign In / Providers (ou "Settings", dependendo da
--    versão do painel) → desligue "Allow new users to sign up" (cadastro
--    público). Isso é ESSENCIAL: sem isso, qualquer pessoa poderia criar
--    a própria conta direto pela API pública, mesmo sem um formulário de
--    cadastro no site.
--
-- Veja o passo a passo completo, com prints e explicações, no README.md.
-- =========================================================
