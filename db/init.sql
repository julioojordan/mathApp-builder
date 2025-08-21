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


-- =========================================
-- DUMMY DATA
-- =========================================

-- ==== USERS ====
INSERT INTO users (id, name) VALUES
(1, 'Dummy User');

-- ==== LESSONS ====
INSERT INTO lessons (id, title) VALUES
(1, 'Basic Arithmetic - Addition/Subtraction'),
(2, 'Multiplication Mastery - Times Tables'),
(3, 'Division Basics - Simple Division');

-- ==== PROBLEMS ====
-- lesson 1: 3 problems (2 multiple, 1 text)
INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
-- P1: multiple (5+3)
(1, 1, 10, 'multiple', '{"text":"What is 5 + 3?"}'),
-- P2: multiple (10-4)
(2, 1, 10, 'multiple', '{"text":"What is 10 - 4?"}'),
-- P3: text (12-7)
(3, 1, 10, 'text',     '{"text":"Solve: 12 - 7"}');

-- lesson 2: 3 problems (2 multiple incl. 1 with image, 1 text)
INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
-- P4: multiple (7x6)
(4, 2, 10, 'multiple', '{"text":"What is 7 × 6?"}'),
-- P5: multiple with image (3x4 visual)
(5, 2, 10, 'multiple', '{
  "image": "/cube_4cm.png",
  "alt": "Cube structure with side 4 cm",
  "text": "What is the total surface area of the cube?"
}'),
-- P6: text (9x9)
(6, 2, 10, 'text',     '{"text":"Solve: 9 × 9"}');

-- lesson 3: 3 problems (2 multiple, 1 text)
INSERT INTO problems (id, lesson_id, exp, type, meta_json) VALUES
-- P7: multiple (12÷3)
(7, 3, 10, 'multiple', '{"text":"What is 12 ÷ 3?"}'),
-- P8: multiple (20÷4)
(8, 3, 10, 'multiple', '{"text":"What is 20 ÷ 4?"}'),
-- P9: text (15÷5)
(9, 3, 10, 'text',     '{"text":"Solve: 15 ÷ 5"}');

-- ==== PROBLEM OPTIONS ====

-- L1 P1 (5+3=8)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(1,'10',FALSE),(1,'12',FALSE),(1,'5',FALSE),(1,'8',TRUE);

-- L1 P2 (10-4=6)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(2,'10',FALSE),(2,'5',FALSE),(2,'7',FALSE),(2,'6',TRUE);

-- L1 P3 (12-7=5) -> text
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(3,'5',TRUE);

-- L2 P4 (7×6=42)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(4,'44',FALSE),(4,'45',FALSE),(4,'48',FALSE),(4,'42',TRUE);

-- L2 P5 (image: Cube)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(5,'84 cm²',FALSE),
(5,'100 cm²',FALSE),
(5,'120 cm²',FALSE),
(5,'96 cm²',TRUE);

-- L2 P6 (9×9=81) -> text
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(6,'81',TRUE);

-- L3 P7 (12÷3=4)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(7,'6',FALSE),(7,'8',FALSE),(7,'9',FALSE),(7,'4',TRUE);

-- L3 P8 (20÷4=5)
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(8,'6',FALSE),(8,'8',FALSE),(8,'10',FALSE),(8,'5',TRUE);

-- L3 P9 (15÷5=3) -> text
INSERT INTO problem_options (problem_id, label, is_correct) VALUES
(9,'3',TRUE);

