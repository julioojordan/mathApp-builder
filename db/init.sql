SET client_encoding = 'UTF8';

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id             BIGSERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  exp            BIGINT    NOT NULL DEFAULT 0,
  last_streak    TIMESTAMPTZ NOT NULL DEFAULT now(),
  current_streak BIGINT    NOT NULL DEFAULT 0,
  best_streak    BIGINT    NOT NULL DEFAULT 0
);

CREATE TABLE lessons (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE problems (
  id         BIGSERIAL PRIMARY KEY,
  lesson_id  BIGINT NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  exp        BIGINT NOT NULL DEFAULT 0,
  type       TEXT NOT NULL,
  meta_json  JSONB
);

CREATE INDEX idx_problems_lesson ON problems(lesson_id);

CREATE TABLE problem_options (
  id          BIGSERIAL PRIMARY KEY,
  problem_id  BIGINT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  label       TEXT NOT NULL,
  is_correct  BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX idx_problem_options_problem ON problem_options(problem_id);

CREATE TABLE submissions (
  id            BIGSERIAL PRIMARY KEY,
  user_id       BIGINT NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
  lesson_id     BIGINT NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  attempt_id    UUID   NOT NULL,
  submitted_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  meta_json     JSONB,
  UNIQUE (user_id, lesson_id, attempt_id)
);

CREATE INDEX idx_submissions_user         ON submissions(user_id);
CREATE INDEX idx_submissions_lesson       ON submissions(lesson_id);
CREATE INDEX idx_submissions_user_lesson  ON submissions(user_id, lesson_id);

CREATE TABLE user_progress (
  user_id         BIGINT NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
  lesson_id       BIGINT NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  completed       BOOLEAN NOT NULL DEFAULT FALSE,
  lesson_progress REAL   NOT NULL DEFAULT 0 CHECK (lesson_progress >= 0 AND lesson_progress <= 1),
  earned_exp      BIGINT    NOT NULL DEFAULT 0,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  meta_json       JSONB,
  PRIMARY KEY (user_id, lesson_id)
);

CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_lesson ON user_progress(lesson_id);


INSERT INTO users (id, name, last_streak) 
VALUES (1, 'Dummy User', NOW() - INTERVAL '1 day');


INSERT INTO lessons (id, title) VALUES
(1, 'Basic Arithmetic - Addition/Subtraction'),
(2, 'Multiplication Mastery - Times Tables'),
(3, 'Division Basics - Simple Division');


INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
(1, 1, 10, 'multiple', '{"text":"What is 5 + 3?"}'),
(2, 1, 10, 'multiple', '{"text":"What is 10 - 4?"}'),
(3, 1, 10, 'text',     '{"text":"Solve: 12 - 7"}');


INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
(4, 2, 10, 'multiple', '{"text":"What is 7 × 6?"}'),
(5, 2, 10, 'multiple', '{
  "image": "/cube_4cm.png",
  "alt": "Cube structure with side 4 cm",
  "text": "What is the total surface area of the cube?"
}'),
(6, 2, 10, 'text',     '{"text":"Solve: 9 × 9"}');

-- lesson 3: 3 problems (2 multiple, 1 text)
INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
(7, 3, 10, 'multiple', '{"text":"What is 12 ÷ 3?"}'),
(8, 3, 10, 'multiple', '{"text":"What is 20 ÷ 4?"}'),
(9, 3, 10, 'text',     '{"text":"Solve: 15 ÷ 5"}');




INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(1,'10',FALSE),(1,'12',FALSE),(1,'5',FALSE),(1,'8',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(2,'10',FALSE),(2,'5',FALSE),(2,'7',FALSE),(2,'6',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(3,'5',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(4,'44',FALSE),(4,'45',FALSE),(4,'48',FALSE),(4,'42',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(5,'84 cm²',FALSE),
(5,'100 cm²',FALSE),
(5,'120 cm²',FALSE),
(5,'96 cm²',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(6,'81',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(7,'6',FALSE),(7,'8',FALSE),(7,'9',FALSE),(7,'4',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(8,'6',FALSE),(8,'8',FALSE),(8,'10',FALSE),(8,'5',TRUE);


INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(9,'3',TRUE);

