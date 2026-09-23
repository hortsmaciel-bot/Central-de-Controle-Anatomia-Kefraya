-- =========================================================
-- Central de Controle Operacional — Anatomia · Grupo Kefraya
-- Script de configuração do banco compartilhado (Supabase)
-- =========================================================
-- Cole este script inteiro no SQL Editor do seu projeto Supabase
-- (menu lateral "SQL Editor" → "New query") e clique em "Run".
-- Antes de rodar, troque a senha de exemplo na linha marcada com
-- "TROQUE-ESTA-SENHA" mais abaixo.

-- 1) Extensão usada para guardar a senha de forma segura (hash), nunca em texto puro
create extension if not exists pgcrypto;

-- 2) Tabela com o estado inteiro do quadro (um único registro/linha)
create table if not exists board_state (
  id text primary key default 'kefraya-anatomia',
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into board_state (id, data)
values ('kefraya-anatomia', '{}'::jsonb)
on conflict (id) do nothing;

alter table board_state enable row level security;

-- leitura pública: qualquer pessoa com o link do site pode VER o quadro
drop policy if exists "Qualquer pessoa pode ler o quadro" on board_state;
create policy "Qualquer pessoa pode ler o quadro"
  on board_state for select
  using (true);

grant select on board_state to anon, authenticated;
revoke insert, update, delete on board_state from anon, authenticated;
-- (de propósito: ninguém grava direto na tabela — só a função abaixo,
--  que confere a senha antes de gravar, pode alterar os dados)

-- 3) Tabela da senha da equipe — totalmente inacessível via API,
--    só a função "security definer" abaixo consegue enxergá-la
create table if not exists app_secrets (
  id text primary key,
  secret_hash text not null
);
alter table app_secrets enable row level security;
revoke all on app_secrets from anon, authenticated;
-- (sem nenhuma "policy" criada = ninguém de fora consegue ler esta tabela)

-- 4) Defina a senha da equipe aqui (troque o texto entre aspas):
insert into app_secrets (id, secret_hash)
values ('edit-password', crypt('TROQUE-ESTA-SENHA', gen_salt('bf')))
on conflict (id) do update set secret_hash = excluded.secret_hash;

-- 5) Função que confere se uma senha está correta (sem revelar a senha real)
create or replace function verify_password(p_password text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  stored text;
begin
  select secret_hash into stored from app_secrets where id = 'edit-password';
  if stored is null then return false; end if;
  return stored = crypt(p_password, stored);
end;
$$;

-- 6) Função que só grava o quadro se a senha estiver correta
create or replace function update_board_state(p_data jsonb, p_password text)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  stored text;
  new_ts timestamptz;
begin
  select secret_hash into stored from app_secrets where id = 'edit-password';
  if stored is null or stored <> crypt(p_password, stored) then
    raise exception 'senha incorreta';
  end if;
  update board_state
    set data = p_data, updated_at = now()
    where id = 'kefraya-anatomia'
    returning updated_at into new_ts;
  return new_ts;
end;
$$;

-- 7) Permitir que o site (usando a chave pública "anon") chame essas duas funções
grant execute on function verify_password(text) to anon, authenticated;
grant execute on function update_board_state(jsonb, text) to anon, authenticated;

-- 8) Ativar atualização ao vivo (Realtime) nesta tabela — assim, quando
--    alguém publica uma alteração, todo mundo com o site aberto vê na hora
alter publication supabase_realtime add table board_state;

-- =========================================================
-- Para TROCAR a senha da equipe depois, rode só este bloco de novo
-- (mesma sintaxe do passo 4), com a senha nova:
--
-- insert into app_secrets (id, secret_hash)
-- values ('edit-password', crypt('SUA-NOVA-SENHA', gen_salt('bf')))
-- on conflict (id) do update set secret_hash = excluded.secret_hash;
-- =========================================================
