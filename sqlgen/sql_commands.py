def insert(table, values):
    joined_values = ", ".join(map(str, values))
    return f"INSERT INTO {table} VALUES {joined_values};"
