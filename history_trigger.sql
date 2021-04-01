DROP TABLE history;

CREATE TABLE history
(
    id SERIAL PRIMARY KEY,
    type_id int REFERENCES piece_types (id) NOT NULL,
    old_x   int CHECK ( old_x > -1 AND old_x < 8 ),
    old_y   int CHECK ( old_y > -1 AND old_y < 8 ),
    new_x   int CHECK ( new_x > -1 AND new_x < 8 ),
    new_y   int CHECK ( new_y > -1 AND new_y < 8 )
);

CREATE OR REPLACE FUNCTION add_move_to_history() RETURNS trigger
    LANGUAGE plpgsql AS
$$
BEGIN
    INSERT INTO history (type_id, old_x, old_y, new_x, new_y)
    VALUES (OLD.type_id , OLD.x, OLD.y, NEW.x, NEW.y);
    RETURN NEW;
END;
$$;

CREATE TRIGGER log_moves
    AFTER UPDATE
    ON pieces
    FOR EACH ROW
EXECUTE FUNCTION add_move_to_history();

CREATE TRIGGER log_deaths
    AFTER DELETE
    ON pieces
    FOR EACH ROW
EXECUTE FUNCTION add_move_to_history();
