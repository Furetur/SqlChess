create or replace function get_piece_by_id(piece_id pieces.type_id%type)
    returns table
            (
                color piece_types.color%type,
                x     pieces.x%type,
                y     pieces.y%type
            )
    language plpgsql
as
$$
begin
    return query (select pt.color as color, pieces.x as x, pieces.y as y
                  from pieces
                           inner join piece_types pt on pt.id = pieces.type_id
                  where pieces.type_id = piece_id);
end;
$$;

create or replace function get_piece_coordinates(
    piece_id pieces.type_id%type,
    out x pieces.x%type,
    out y pieces.y%type
)
    language plpgsql as
$$
begin
    x := (select pieces.x from pieces where pieces.type_id = piece_id);
    y := (select pieces.y from pieces where pieces.type_id = piece_id);
end;
$$;

create or replace function get_piece_by_coordinates(
    xx pieces.x%type,
    yy pieces.y%type
)
    returns table
            (
                id    pieces.type_id%type,
                color piece_types.color%type
            )
    language plpgsql
as
$$
begin
    return query (select pieces.type_id as id, pt.color as color
                  from pieces
                           inner join piece_types pt on pt.id = pieces.type_id
                  where pieces.x = xx
                    and pieces.y = yy);
end;

$$;



create or replace procedure move_piece_no_constraints(
    piece_id pieces.type_id%type,
    x pieces.x%type,
    y pieces.y%type
)
    language plpgsql as
$$
declare
    old_x                      pieces.x%type;
    old_y                      pieces.y%type;
    this_color                 piece_types.color%type;
    piece_color_in_destination piece_types.color%type;
begin
    old_x := (select piece.x from get_piece_coordinates(piece_id) as piece);
    old_y := (select piece.y from get_piece_coordinates(piece_id) as piece);

    if old_x is null or old_y is null then
        raise exception 'The piece with id % is not on board', piece_id;
    elsif old_x = x and old_y = y then
        raise exception 'The source and destination are the same: moving % from (%, %) to (%, %)', piece_id, old_x, old_y, x, y;
    end if;

    this_color := (select color from get_piece_by_id(piece_id));
    piece_color_in_destination := (select color from get_piece_by_coordinates(x, y));

    if this_color = piece_color_in_destination then
        raise exception 'Trying to move piece to cell where there is a piece of the same color';
    elsif piece_color_in_destination is not null then
        delete from pieces where pieces.x = move_piece_no_constraints.x and pieces.y = move_piece_no_constraints.y;
    end if;

    update pieces
    set x = move_piece_no_constraints.x,
        y = move_piece_no_constraints.y
    where type_id = piece_id;
end;
$$;

call move_piece_no_constraints(0, 1, 6);
