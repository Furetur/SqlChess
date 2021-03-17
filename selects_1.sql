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

-- VIEW
CREATE VIEW pieces_full_info AS
SELECT *
FROM piece_types
         INNER JOIN pieces ON piece_types.id = pieces.type_id;

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

-- using view `pieces_full_info`
SELECT piece.*
FROM pieces_full_info as piece,
     pieces_full_info as rook
WHERE rook.type_id = 0
  AND (piece.x = rook.x
    OR piece.y = rook.y);
-- 12
SELECT color
from (SELECT color, type, count(*) as count
      FROM piece_types
               INNER JOIN pieces ON piece_types.id = pieces.type_id
      GROUP BY color, type) AS t
WHERE t.type = 'pawn'
  AND t.count = 8;
-- 13
SELECT *
INTO new_pieces
FROM pieces;

UPDATE new_pieces
SET x=5,
    y=5
WHERE type_id = 0; -- moves a white rook somewhere
DELETE
FROM new_pieces
WHERE type_id = 8; -- deletes a white pawn

SELECT *
FROM pieces
         LEFT JOIN new_pieces np on pieces.type_id = np.type_id
WHERE np.type_id is null
   OR pieces.x != np.x
   OR pieces.y != np.y;
-- 14
-- using view `pieces_full_info`
SELECT piece.*
FROM pieces_full_info piece,
     pieces_full_info king
WHERE king.type_id = 28
  AND piece.type_id != 28
  AND abs(piece.x - king.x) <= 2
  AND abs(piece.y - king.y) <= 2;
-- 15
CREATE VIEW pieces_with_distances AS
SELECT piece.*, abs(piece.x - king.x) + abs(piece.y - king.y) as l1
FROM pieces_full_info piece,
     pieces_full_info king
WHERE king.type_id = 4
  AND piece.type_id != 4
ORDER BY l1;

CREATE VIEW smallest_l1 AS
SELECT l1 FROM pieces_with_distances LIMIT 1;

SELECT pieces_with_distances.*
FROM pieces_with_distances, smallest_l1
WHERE pieces_with_distances.l1 = smallest_l1.l1;
