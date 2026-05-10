-- エピソード視聴数トップ3のエピソードタイトルと視聴数を取得
SELECT
  e.title            AS episode_title,
  SUM(sev.views)     AS total_views
FROM slot_episode_views sev
JOIN time_slots ts ON ts.id = sev.time_slot_id
JOIN episodes   e ON e.id = sev.episode_id
GROUP BY e.title
ORDER BY total_views DESC
LIMIT 3;

-- エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得
SELECT
  e.title            AS episode_title,
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  SUM(sev.views)     AS total_views
FROM slot_episode_views sev
JOIN time_slots ts ON ts.id = sev.time_slot_id
JOIN episodes   e ON e.id = sev.episode_id
JOIN seasons    s ON s.id = e.season_id
JOIN programs   p ON p.id = s.program_id
GROUP BY e.title, p.title, s.season_number, e.episode_number
ORDER BY total_views DESC
LIMIT 3;

-- チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得
SELECT
  ch.name            AS channel_name,
  ts.start_time,
  ts.end_time,
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  e.description
FROM time_slots ts
JOIN channels   ch ON ch.id = ts.channel_id
JOIN programs   p ON p.id = ts.program_id
JOIN seasons    s ON s.program_id = p.id
JOIN episodes   e ON e.season_id  = s.id
WHERE DATE(ts.start_time) = CURDATE();

-- 放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得
SELECT
  ch.name            AS channel_name,
  ts.start_time,
  ts.end_time,
  p.title            AS program_title,
  s.season_number,
  e.episode_number,
  e.title            AS episode_title,
  e.description
FROM time_slots ts
JOIN channels   ch ON ch.id = ts.channel_id
JOIN programs   p ON p.id = ts.program_id
JOIN seasons    s ON s.program_id = p.id
JOIN episodes   e ON e.season_id  = s.id
WHERE DATE(ts.start_time) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
AND ch.name = 'ドラマch';