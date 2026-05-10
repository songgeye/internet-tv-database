-- チャンネル一覧を取得
SELECT
  id,
  name,
  description
FROM channels
ORDER BY id;

-- あるチャンネルの番組表(番組枠一覧)を取得
SELECT
  ts.id           AS time_slot_id,
  ch.id,
  ts.start_time,
  ts.end_time,
  p.id            AS program_id,
  p.title         AS program_title,
  p.is_series
FROM time_slots ts
JOIN channels ch ON ch.id = ts.channel_id
JOIN programs p ON p.id = ts.program_id
WHERE ts.channel_id = 1
ORDER BY ts.start_time;

-- 番組IDを指定し、その番組に紐づくシーズン一覧を取得
SELECT
  s.id            AS season_id,
  s.program_id,
  s.season_number
FROM seasons s
WHERE s.program_id = 1
ORDER BY s.season_number;

-- 番組詳細(タイトル・説明・ジャンル)を取得
SELECT
  p.id,
  p.title,
  p.description,
  p.is_series,
  GROUP_CONCAT(g.name ORDER BY g.name SEPARATOR ', ') AS genres
FROM programs p
JOIN program_genres pg ON pg.program_id = p.id
JOIN genres g          ON g.id = pg.genre_id
WHERE p.id = 1
GROUP BY p.id, p.title, p.description, p.is_series;

-- 番組に紐づくエピソード一覧を取得
SELECT
  e.id               AS episode_id,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  e.description,
  e.duration_seconds,
  e.release_date,
  e.total_views
FROM episodes e
JOIN seasons s ON s.id = e.season_id
WHERE s.program_id = 1
ORDER BY s.season_number, e.episode_number;

-- エピソード詳細を1件取得
SELECT
  e.id,
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  e.description,
  e.duration_seconds,
  e.release_date,
  e.total_views
FROM episodes e
JOIN seasons  s ON s.id = e.season_id
JOIN programs p ON p.id = s.program_id
WHERE e.id = 1;

-- 番組枠×エピソードごとの視聴数(KPI)を取得
SELECT
  ch.name            AS channel_name,
  ts.start_time,
  ts.end_time,
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  sev.views
FROM slot_episode_views sev
JOIN time_slots ts  ON ts.id  = sev.time_slot_id
JOIN channels   ch  ON ch.id  = ts.channel_id
JOIN programs   p   ON p.id   = ts.program_id
JOIN episodes   e   ON e.id   = sev.episode_id
JOIN seasons    s   ON s.id   = e.season_id
ORDER BY ch.id, ts.start_time, s.season_number, e.episode_number;

-- 視聴数上位10件のエピソードを取得
SELECT
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  e.total_views
FROM episodes e
JOIN seasons  s ON s.id = e.season_id
JOIN programs p ON p.id = s.program_id
ORDER BY e.total_views DESC
LIMIT 10;

-- チャンネルごとの視聴数を取得
SELECT
  ch.id,
  ch.name            AS channel_name,
  SUM(sev.views)     AS total_views
FROM slot_episode_views sev
JOIN time_slots ts ON ts.id = sev.time_slot_id
JOIN channels   ch ON ch.id = ts.channel_id
GROUP BY ch.id, ch.name
ORDER BY total_views DESC;