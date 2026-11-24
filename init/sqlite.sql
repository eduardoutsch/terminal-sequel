-- Shared sample schema for SQLite (CMU 15-445 style)
PRAGMA foreign_keys = ON;

CREATE TABLE student (
    sid INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT UNIQUE NOT NULL,
    age INTEGER,
    gpa REAL
);

CREATE TABLE course (
    cid TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE enrolled (
    sid INTEGER REFERENCES student(sid),
    cid TEXT REFERENCES course(cid),
    grade TEXT,
    PRIMARY KEY (sid, cid)
);

INSERT INTO student (sid, name, login, age, gpa) VALUES
    (53666, 'Kanye',   'kanye@cs',   44, 4.00),
    (53688, 'Bieber',  'bieber@cs',  29, 3.90),
    (53655, 'Tupac',   'tupac@cs',   25, 3.50),
    (53699, 'Taylor',  'taylor@cs',  34, 3.85),
    (53700, 'Ada',     'ada@cs',     36, NULL);

INSERT INTO course (cid, name) VALUES
    ('15-445', 'Database Systems'),
    ('15-721', 'Advanced Database Systems'),
    ('15-826', 'Multimedia Databases');

INSERT INTO enrolled (sid, cid, grade) VALUES
    (53666, '15-445', 'C'),
    (53688, '15-721', 'A'),
    (53688, '15-826', 'B'),
    (53655, '15-445', 'B'),
    (53699, '15-445', 'A'),
    (53700, '15-445', NULL);
