CREATE TABLE IF NOT EXISTS colors
(
    name char(5) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS piece_types
(
    type char(10) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS pieces
(
    type  char(10) REFERENCES piece_types (type) NOT NULL,
    color char(5) REFERENCES colors (name)       NOT NULL,
    x     int CHECK ( x > -1 AND x < 8 )          NOT NULL,
    y     int CHECK ( y > -1 OR y < 8 )          NOT NULL,
    PRIMARY KEY (type, color),
    UNIQUE (x, y)
)

/* All enums: */

INSERT INTO colors
VALUES ('BLACK'),
       ('WHITE');

INSERT INTO piece_types
VALUES ('KING'),
       ('QUEEN'),
       ('ROOK1'),
       ('ROOK2'),
       ('BISHOP1'),
       ('BISHOP2'),
       ('KNIGHT1'),
       ('KNIGHT2'),
       ('PAWN1'),
       ('PAWN2'),
       ('PAWN3'),
       ('PAWN4'),
       ('PAWN5'),
       ('PAWN6'),
       ('PAWN7'),
       ('PAWN8');
