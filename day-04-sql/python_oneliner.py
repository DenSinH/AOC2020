import re
print((lambda text: sum([1 for t in text.split("\n\n") if {keyval[:3] for keyval in t.split()} == set("byr iyr eyr hgt hcl ecl pid".split())]))(open("./input.txt", "r").read()))
constraints = {
    "byr": (r"(\d{4})(?:\Z|\s)", lambda v: 2002 >= int(v) >= 1920),
    "iyr": (r"(\d{4})(?:\Z|\s)", lambda v: 2020 >= int(v) >= 2010),
    "eyr": (r"(\d{4})(?:\Z|\s)", lambda v: 2030 >= int(v) >= 2020),
    "hgt": (r"(\d{3}cm|\d{2}in)", lambda v: (v.endswith("cm") and 193 >= int(v[:3]) >= 150) or (v.endswith("in") and 76 >= int(v[:2]) >= 59)),
    "hcl": (r"(#[0-9a-f]{6})(\Z|\s)", lambda v: True),                           # if it matches, it's always correct
    "ecl": (r"(amb|blu|brn|gry|grn|hzl|oth)(?:\Z|\s)", lambda v: True),  # same here
    "pid": (r"(\d{9})(?:\Z|\s)", lambda v: True),                          # here too
}
print((lambda text: sum([all([re.search(field + ":" + regex, line.replace("\n", " ")) and func(re.search(field + ":" + regex, line.replace("\n", " ")).group(1)) for field, (regex, func) in constraints.items()]) for line in text.split("\n\n")]))(open("input.txt", "r").read()))