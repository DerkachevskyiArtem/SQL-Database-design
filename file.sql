CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64),
  nickname VARCHAR(64) NOT NULL UNIQUE,
  email VARCHAR(256) NOT NULL CHECK (email != '') UNIQUE,
  password VARCHAR(256) NOT NULL CHECK (password != ''),
  birthday DATE CHECK (birthday > '1890-01-01' AND birthday <= current_date),
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE videos (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  description TEXT,
  likes INT DEFAULT 0,
  dislikes INT DEFAULT 0,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE playlists (
  id SERIAL PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  description TEXT,
  access_type VARCHAR(32) NOT NULL CHECK (access_type IN ('public', 'private', 'restricted')),
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE playlist_videos (
  playlist_id INT NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
  video_id INT NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  PRIMARY KEY (playlist_id, video_id),
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE playlist_access (
  playlist_id INT NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY (playlist_id, user_id),
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  text TEXT NOT NULL,
  likes INT DEFAULT 0,
  dislikes INT DEFAULT 0,
  video_id INT NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE reactions (
  id SERIAL PRIMARY KEY,
  reaction_type VARCHAR(32) NOT NULL CHECK (reaction_type IN ('like', 'dislike')),
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  video_id INT REFERENCES videos(id) ON DELETE CASCADE,
  comment_id INT REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  UNIQUE (user_id, video_id),
  UNIQUE (user_id, comment_id)
);