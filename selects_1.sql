-- CREATE TABLE IF NOT EXISTS piece_types
-- (
--     id    SERIAL PRIMARY KEY,
--     type  char(10) NOT NULL,
--     color char(5)  NOT NULL
-- );
--
-- CREATE TABLE IF NOT EXISTS pieces
-- (
--     type_id int REFERENCES piece_types (id) NOT NULL,
--     x       int CHECK ( x > -1 AND x < 8 )  NOT NULL,
--     y       int CHECK ( y > -1 OR y < 8 )   NOT NULL,
--     UNIQUE (type_id),
--     UNIQUE (x, y)
-- )

-- 1
SELECT count(type_id)
FROM pieces;
-- 2
SELECT id
FROM piece_types
WHERE type ILIKE 'k%';
-- 3
SELECT type, count(id)
FROM piece_types
GROUP BY type;
-- 4
SELECT type_id
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id
WHERE color = 'white'
  AND type = 'pawn';
-- 5
SELECT type, color, x, y
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id
WHERE x = y;
-- 6
SELECT color, count(*)
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id
GROUP BY color;
-- 7
SELECT type
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id
WHERE color = 'black';
-- 8
SELECT type, count(*)
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id
WHERE color = 'black'
GROUP BY type;
-- 9
SELECT type, t.count
from (SELECT type, count(*)
      FROM piece_types
               INNER JOIN pieces ON piece_types.id = pieces.type_id
      GROUP BY type) AS t
WHERE t.count >= 2;
-- 10
SELECT color, t.count
from (SELECT color, count(*)
      FROM piece_types
               INNER JOIN pieces ON piece_types.id = pieces.type_id
      GROUP BY color) AS t
ORDER BY t.count DESC
LIMIT 1;
-- 11
-- For rook (type_id=0, type=rook, color=white, x=0, y=0)
SELECT type, color
from (SELECT *
      FROM piece_types
               INNER JOIN pieces ON piece_types.id = pieces.type_id
      ) as t
WHERE x = 0 OR y = 0;
-- 12
SELECT color
from (SELECT color, type, count(*) as count
      FROM piece_types
               INNER JOIN pieces ON piece_types.id = pieces.type_id
      GROUP BY color, type) AS t
WHERE t.type = 'pawn' AND t.count = 8;