# Water Tracker

Flutter-приложение «трекер воды» с бэкендом на Supabase.

## Запуск

Передайте URL проекта и anon key через `--dart-define` (значения возьмите в [Supabase Dashboard](https://supabase.com/dashboard) → Project Settings → API):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
```

### Локальный скрипт `run.sh`

В репозитории `run.sh` в **`.gitignore`** (чтобы не закоммитить секреты). Создайте файл `run.sh` рядом с `pubspec.yaml`:

```bash
#!/usr/bin/env bash
set -euo pipefail
flutter run \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"
```

Перед запуском задайте переменные окружения:

```bash
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_ANON_KEY="eyJhbGci..."
chmod +x run.sh
./run.sh
```

## Тесты

В `widget_test` Supabase инициализируется в `setUpAll` тестовыми значениями (без сетевых запросов до первого обращения к API).

```bash
flutter test
```

## Supabase: полный SQL (SQL Editor)

Скопируйте блок ниже в **SQL → New query** и выполните целиком. При повторном запуске сначала удалите конфликтующие объекты или выполняйте на чистом проекте.

```sql
-- Таблицы, индекс, RLS, триггер нового пользователя, RPC для дневной суммы и статистики по диапазону дат.

-- ---------------------------------------------------------------------------
-- Таблицы
-- ---------------------------------------------------------------------------

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  daily_goal_ml integer not null default 2000,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.water_intakes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  amount_ml integer not null check (amount_ml > 0),
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists water_intakes_user_id_created_at_idx
  on public.water_intakes (user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Триггер: профиль при регистрации
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(split_part(new.email, '@', 1), 'user')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute procedure public.handle_new_user();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.water_intakes enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles
  for select
  to authenticated
  using (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles
  for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "water_intakes_select_own" on public.water_intakes;
create policy "water_intakes_select_own"
  on public.water_intakes
  for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "water_intakes_insert_own" on public.water_intakes;
create policy "water_intakes_insert_own"
  on public.water_intakes
  for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "water_intakes_update_own" on public.water_intakes;
create policy "water_intakes_update_own"
  on public.water_intakes
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "water_intakes_delete_own" on public.water_intakes;
create policy "water_intakes_delete_own"
  on public.water_intakes
  for delete
  to authenticated
  using (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- RPC: сумма за «сегодня» по UTC-календарной дате
-- ---------------------------------------------------------------------------

create or replace function public.get_today_intake()
returns bigint
language sql
stable
security invoker
set search_path = public
as $$
  select coalesce(sum(amount_ml), 0)::bigint
  from public.water_intakes
  where user_id = auth.uid()
    and (created_at at time zone 'utc')::date
      = (timezone('utc', now()))::date;
$$;

-- ---------------------------------------------------------------------------
-- RPC: суммы по дням в диапазоне [p_start, p_end] (UTC-дата intakes)
-- ---------------------------------------------------------------------------

create or replace function public.get_stats_range(p_start date, p_end date)
returns table (day date, total_ml bigint)
language sql
stable
security invoker
set search_path = public
as $$
  with days as (
    select d::date as day
    from generate_series(
      p_start::timestamp,
      p_end::timestamp,
      interval '1 day'
    ) as g(d)
  )
  select
    d.day,
    coalesce(sum(w.amount_ml), 0)::bigint as total_ml
  from days d
  left join public.water_intakes w
    on w.user_id = auth.uid()
   and (w.created_at at time zone 'utc')::date = d.day
  group by d.day
  order by d.day;
$$;

-- ---------------------------------------------------------------------------
-- Права
-- ---------------------------------------------------------------------------

grant usage on schema public to anon, authenticated;

grant select, update on public.profiles to authenticated;
grant select, insert, update, delete on public.water_intakes to authenticated;

grant execute on function public.get_today_intake() to authenticated;
grant execute on function public.get_stats_range(date, date) to authenticated;
```

> План из чата с точным текстом SQL недоступен; схема выше соответствует типичному трекеру воды (`profiles`, `water_intakes`, RLS, `handle_new_user`, `get_today_intake`, `get_stats_range`). При необходимости скорректируйте поля под ваш макет.
