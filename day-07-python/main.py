from typing import Dict, List, Tuple
from functools import reduce
import re

with open("input.txt", "r") as f:
    rules_txt = f.readlines()

rules: Dict[str, List[Tuple[int, str]]] = {}
for rule in rules_txt:
    bag = re.match("^(.*?) bags contain", rule).group(1)
    rules[bag] = [(int(n), b) for n, b in re.findall(r"(\d+) (.*?) bags?", rule)]


def dep(bag):
    return reduce(lambda acc, x: acc | ({x[1]} | dep(x[1])) if x[1] not in acc else acc, rules[bag], set())


def inside(bag):
    return sum([n + n * inside(typ) for n, typ in rules[bag]])


print("PART 1", len(list(filter(lambda bag: "shiny gold" in dep(bag), rules.keys()))))
print("PART 2", inside("shiny gold"))