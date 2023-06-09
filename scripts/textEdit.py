with open("tiles.txt", "r") as f:
    tiles = f.readlines()

tilenames = []
for tile in tiles:
    tilenames.append('"' + ''.join(c for c in tile if c not in " \t\n") + '"')