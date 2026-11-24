-- Shared sample schema for PostgreSQL (CMU 15-445 style)

CREATE TABLE student (
    sid INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    login VARCHAR(64) UNIQUE NOT NULL,
    age INT,
    gpa NUMERIC(3, 2)
);

CREATE TABLE course (
    cid VARCHAR(16) PRIMARY KEY,
    name VARCHAR(128) NOT NULL
);

CREATE TABLE enrolled (
    sid INT REFERENCES student(sid),
    cid VARCHAR(16) REFERENCES course(cid),
    grade VARCHAR(2),
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
