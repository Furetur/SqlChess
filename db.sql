DROP TABLE IF EXISTS pieces;
DROP TABLE IF EXISTS piece_types;


CREATE TABLE IF NOT EXISTS piece_types
(
    id    SERIAL PRIMARY KEY,
    type  char(10) NOT NULL,
    color char(5)  NOT NULL
);

CREATE TABLE IF NOT EXISTS pieces
(
    type_id int REFERENCES piece_types (id) NOT NULL,
    x       int CHECK ( x > -1 AND x < 8 )  NOT NULL,
    y       int CHECK ( y > -1 OR y < 8 )   NOT NULL,
    UNIQUE (type_id),
    UNIQUE (x, y)
)
