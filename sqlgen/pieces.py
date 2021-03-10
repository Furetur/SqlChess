from dataclasses import dataclass
from enum import Enum

from sqlgen.sql_commands import insert


class BaseType(Enum):
    KING = 'king'
    QUEEN = 'queen'
    ROOK = 'rook'
    BISHOP = 'bishop'
    KNIGHT = 'knight'
    PAWN = 'pawn'


class Color(Enum):
    WHITE = 'white'
    BLACK = 'black'


@dataclass(frozen=True)
class PieceType:
    id: int
    type: BaseType
    color: Color

    def to_sql_tuple(self):
        return self.id, self.type.value, self.color.value

    def __str__(self):
        return f"#{self.id} {self.color.value} {self.type.value}"


@dataclass(frozen=True)
class Piece:
    piece_type: PieceType
    x: int
    y: int

    def to_sql_tuple(self):
        return self.piece_type.id, self.x, self.y

    def __str__(self):
        return f"{self.piece_type} at ({self.x}, {self.y})"
