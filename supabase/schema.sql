-- StudyBuddy Supabase schema
-- Run this entire file in Supabase Dashboard -> SQL Editor.
-- Row Level Security ensures each signed-in student can access only their own rows.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 40),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_date date not null,
  minutes integer not null check (minutes between 1 and 1440),
  subject text not null default 'General',
  chapter text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.practice_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  event_date date not null,
  subject text not null default 'Unknown',
  chapter text not null default 'Unspecified',
  correct boolean not null default false,
  question text not null default '' check (char_length(question) <= 220),
  created_at timestamptz not null default now()
);

create table if not exists public.planner_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 240),
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists study_sessions_user_date_idx
  on public.study_sessions (user_id, session_date desc);
create index if not exists practice_events_user_date_idx
  on public.practice_events (user_id, event_date desc);
create index if not exists planner_tasks_user_created_idx
  on public.planner_tasks (user_id, created_at);

alter table public.profiles enable row level security;
alter table public.study_sessions enable row level security;
alter table public.practice_events enable row level security;
alter table public.planner_tasks enable row level security;

drop policy if exists "Students manage their own profile" on public.profiles;
create policy "Students manage their own profile"
  on public.profiles for all to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "Students manage their own study sessions" on public.study_sessions;
create policy "Students manage their own study sessions"
  on public.study_sessions for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Students manage their own practice events" on public.practice_events;
create policy "Students manage their own practice events"
  on public.practice_events for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Students manage their own planner tasks" on public.planner_tasks;
create policy "Students manage their own planner tasks"
  on public.planner_tasks for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.study_sessions to authenticated;
grant select, insert, update, delete on public.practice_events to authenticated;
grant select, insert, update, delete on public.planner_tasks to authenticated;
