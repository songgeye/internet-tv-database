-- チャンネルテーブル
CREATE TABLE channels (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
    PRIMARY KEY (id),
    INDEX idx_channels_name (name),
    UNIQUE KEY uk_channels_name (name)
);

-- 時間枠テーブル
CREATE TABLE time_slots (
    id BIGINT NOT NULL AUTO_INCREMENT,
    channel_id BIGINT NOT NULL,
    program_id BIGINT(20) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_time_slots_chanel_id (channel_id),
    INDEX idx_time_slots_program_id (program_id),
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (program_id) REFERENCES programs(id)
);

-- プログラムテーブル
CREATE TABLE programs (
    id BIGINT NOT NULL AUTO_INCREMENT,
    title BIGINT NOT NULL,
    description TEXT,
    is_series TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_programs_title (title)
)

-- シーズンテーブル
CREATE TABLE seasons (
    id BIGINT NOT NULL AUTO_INCREMENT,
    program_id BIGINT NOT NULL,
    season_number INT,
    PRIMARY KEY (id),
    INDEX idx_seasons_program_id (program_id),
    FOREIGN KEY (program_id) REFERENCES programs(id),
    UNIQUE KEY uk_seasons_program_id_season_number (program_id, season_number)
)

-- エピソードテーブル
CREATE TABLE episodes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    season_id BIGINT NOT NULL,
    episode_number INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    duration_seconds INT NOT NULL,
    release_date DATE NOT NULL,
    total_views BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_episodes_season_id (season_id),
    FOREIGN KEY (season_id) REFERENCES seasons(id),
)

-- ジャンルテーブル
CREATE TABLE genres (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_genres_name (name),
    UNIQUE KEY uk_genres_name (name)
)

-- 番組ジャンル中間テーブル
CREATE TABLE program_genres (
    id BIGINT NOT NULL AUTO_INCREMENT,
    program_id BIGINT NOT NULL,
    genre_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_program_genres_program_id (program_id),
    INDEX idx_program_genres_genre_id (genre_id),
    FOREIGN KEY (program_id) REFERENCES programs(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
    UNIQUE KEY uk_program_genres_program_id_genre_id (program_id, genre_id)
)

-- 番組枠×エピソード視聴数
CREATE TABLE slot_episode_views (
    id BIGINT NOT NULL AUTO_INCREMENT,
    time_slot_id BIGINT NOT NULL,
    episode_id BIGINT NOT NULL,
    views BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_slot_episode_views_time_slot_id (time_slot_id),
    INDEX idx_slot_episode_views_episode_id (episode_id),
    FOREIGN KEY (time_slot_id) REFERENCES time_slots(id),
    FOREIGN KEY (episode_id) REFERENCES episodes(id),
    UNIQUE KEY uk_slot_episode_views_time_slot_id_episode_id (time_slot_id, episode_id)
)