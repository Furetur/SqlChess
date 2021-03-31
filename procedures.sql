create or replace procedure hello_world()
    language plpgsql as
$$
begin
    raise notice 'Hello world';
end;
$$;

call hello_world();

create or replace procedure hello_world()
    language plpgsql as
'
    begin
        raise notice ''Hello world'';
    end;
';

create or replace procedure multiply(
    x int,
    y int
)
    language plpgsql as
$$
declare
    z              int;
    something_else bool;
begin
    z := x * y;
    raise notice 'result: %', x * y;
end;
$$;

call multiply(4, 5);

create or replace procedure print(
    x varchar(50) default 1
)
    language plpgsql as
$$
begin
    raise notice '%', x;
end;
$$;

call print('abba');

call print();

create or replace procedure even(
    upper_bound int
)
    language plpgsql as
$$
begin
    for i in 2..upper_bound
        LOOP
            if i % 2 = 0 then
                raise notice '%', i;
            end if;
        end loop;
end ;
$$;

call even(10);

create or replace procedure move_piece(
    piece_id int,
    x int,
    y int
)
    language plpgsql as
$$

begin
    select * into new_pieces from pieces;
end ;
$$;

create or replace procedure hellop(
    name char(15),
    last_name char(15) default ''
)
    language plpgsql as
-- $$
begin
raise notice 'Hello % %', name, last_name;
end;
-- $$;

call hellop('user');
call hellop('Alice', 'Alice');

create table people
(
    name char(10) not null,
    age  int      not null
);

insert into people
values ('Emir', 13),
       ('Jack', 50);

create procedure twice_age()
    language plpgsql as
$$
begin
    update people set age = age * 2;
end;
$$;

call twice_age();

create or replace procedure twice_age_by_name(
    name people.name%type
)
    language plpgsql as
$$
begin
    update people set age = age * 2 where people.name = twice_age_by_name.name;
end;
$$;

create or replace procedure twice_age_by_name(
    name char(10)
)
    language plpgsql as
-- $$
begin
update people
set age = age * 2
where people.name = twice_age_by_name.name;
end;
-- $$;

call twice_age_by_name('Jack');

create or replace procedure evenq(
    number int
)
    language plpgsql as
-- $$
begin
case number % 2
        when 0 then raise notice 'even';
when 1 then raise notice 'odd';
end case;
end;
-- $$;

call evenq(10);

create or replace function first_function() returns people.age%type
    language plpgsql as
$$
begin
    return (select age from people order by age desc limit 1);
end;
$$;

select first_function();

create procedure second()
    language plpgsql as
-- $$
declare
    max_age people.age%type;
begin
max_age := (select * from first_function());
update people
set age = age * 2
where age = max_age;
end;
-- $$;

call second();

create procedure t(
    number int not null
)
    language plpgsql as
$$
begin
    raise notice '%', number;
end;
$$;

call t(null);

create procedure f()
    language plpgsql as
$$
begin
    return 1;
end;
$$;

create procedure is_even(
    number int,
    inout result bool
)
    language plpgsql as
-- $$
begin
if number % 2 = 0 then
        result := true;
else
        result := false;
end if;
end;
-- $$;

create procedure all_even(
    upper_bound int
)
    language plpgsql as
$$
declare
    result bool;
begin
    for i in 1..upper_bound
        loop
            call is_even(i, result);
            if result is true then
                raise notice 'even %', i;
            end if;
        end loop;
end;
$$;

call all_even(100);

create procedure do_something(
    name people.name%type
)
    language plpgsql as
$$
declare
    row people%ROWTYPE;
begin
    row := (select * from people where age = 2);
end;
$$;

create procedure delete_bad()
    language plpgsql as
-- $$
begin
delete
from people
where age = 12;
end;
-- $$;

call delete_bad();

create or replace procedure d()
    language plpgsql as
$$
begin
    for i in 1..100
        loop
            raise notice '%', i;
        end loop;
end;
$$;

call d();

drop procedure d;

create or replace procedure d(
    b int
)
    language plpgsql as
$$
begin
    for i in 1..100
        loop
            raise notice '%', i;
        end loop;
end;
$$;
create or replace procedure fff(
    variadic xs int[]
)
    language plpgsql as
$$
declare
    x int;
begin
    foreach x in array xs
        loop
            raise notice '%', x;
        end loop;
end;
$$;

call fff(1, 2, 3);





