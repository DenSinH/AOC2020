inp = set(int(n) for n in open("input.txt", "r").readlines())
print("part 1:", [x * (2020 - x) for x in inp if (2020 - x) in inp][0])
print("part 2:", [x * y * (2020 - x - y) for x in inp for y in inp if (2020 - x - y) in inp][0])