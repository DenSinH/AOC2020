import re

# I just can't be bothered to do more string parsing in weird languages
rules = {}
ticket = []
nearby = []
with open("input.txt", "r") as f:
    inp = f.readlines()

i = 0
while inp[i].strip() != "":
    rule = re.match(r"(.+): (\d+)-(\d+) or (\d+)-(\d+)", inp[i])

    rules[rule.group(1)] = ((int(rule.group(2)), int(rule.group(3))), (int(rule.group(4)), int(rule.group(5))))

    i += 1

# newline and "your ticket:" line
i += 2
ticket = [int(n) for n in inp[i].strip().split(",")]

# ticket line, newline and "nearby tickets:" line
i += 3

while i < len(inp):
    nearby.append([int(n) for n in inp[i].strip().split(",")])
    i += 1

invalid = []
for t in nearby:
    invalid += [n for n in t if not any(m1 <= n <= M1 or m2 <= n <= M2 for ((m1, M1), (m2, M2)) in rules.values())]

print "part 1", sum(invalid)

valid = filter(
    lambda t: all(any(m1 <= n <= M1 or m2 <= n <= M2 for ((m1, M1), (m2, M2)) in rules.values()) for n in t),
    nearby
)
# our own ticket is also valid
valid = valid + [ticket]

candidates = {field: set() for field in rules}
for i in xrange(len(ticket)):
    for field in rules:
        ((m1, M1), (m2, M2)) = rules[field]
        if all(m1 <= t[i] <= M1 or m2 <= t[i] <= M2 for t in valid):
            candidates[field].add(i)

# keep deducing options until we found the right ones
while any(len(c) > 1 for c in candidates.values()):
    for field in candidates:
        if len(candidates[field]) == 1:
            # only 1 candidate
            for _field in candidates:
                if _field != field:
                    candidates[_field] -= candidates[field]

part_2 = 1
for field in candidates:
    if field.startswith("departure"):
        part_2 *= ticket[candidates[field].pop()]

print "part 2", part_2