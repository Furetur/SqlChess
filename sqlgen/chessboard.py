from typing import List

import board

from sqlgen.pieces import Color, BaseType, PieceType, Piece
from sqlgen.sql_commands import insert

chessboard = board.Board((8, 8))

types = []
next_type_id = 0


def add_type(type: BaseType, color: Color) -> PieceType:
    global next_type_id
    type = PieceType(next_type_id, type, color)
    types.append(type)
    next_type_id += 1
    return type


def add_types(type: BaseType, color: Color, n_types: int):
    for i in range(n_types):
        add_type(type, color)


def generate_pawn_layer(y: int, color: Color):
    for i in range(8):
        chessboard[i, y] = add_type(BaseType.PAWN, color)


def generate_main_layer(y: int, color: Color):
    x = 0

    def add_piece(base: BaseType):
        nonlocal x
        chessboard[x, y] = add_type(base, color)
        x += 1

    add_piece(BaseType.ROOK)
    add_piece(BaseType.KNIGHT)
    add_piece(BaseType.BISHOP)
    add_piece(BaseType.QUEEN)
    add_piece(BaseType.KING)
    add_piece(BaseType.BISHOP)
    add_piece(BaseType.KNIGHT)
    add_piece(BaseType.ROOK)


def generate_board():
    generate_main_layer(0, Color.WHITE)
    generate_pawn_layer(1, Color.WHITE)
    generate_pawn_layer(6, Color.BLACK)
    generate_main_layer(7, Color.BLACK)


generate_board()
chessboard.draw()


def types_from_board() -> List[PieceType]:
    return [chessboard[coord] for coord in chessboard if chessboard[coord] is not board.Empty]


def pieces_from_board() -> List[Piece]:
    return [Piece(chessboard[coord], coord[0], coord[1]) for coord in chessboard if
            chessboard[coord] is not board.Empty]



print('Types:')

print(insert('pieces_types', [type.to_sql_tuple() for type in types_from_board()]))

print('Pieces:')

print(insert('pieces', [piece.to_sql_tuple() for piece in pieces_from_board()]))


print(pieces_from_board())
print(chessboard[1, 1])
