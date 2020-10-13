"use strict";

const dflt = 1;  // default part to solve


function part1(input) {
    console.log(input);
    return input;
}


function part2(input) {
    console.log(input);
    return input;
}


function main(override) {
    let out = "";

    let radios = document.getElementsByName("part");
    if ((!override && radios[0].checked) || (override && dflt == 1)) {
        out = "Part 1:" + part1(document.getElementById("input").innerHTML);
    }
    else if ((!override && radios[1].checked) || (override && dflt == 2)) {
        out = "Part 2: " + part2(document.getElementById("input").innerHTML);
    }
    else {
        out = "Select a part";
    }
    document.getElementById("solution").innerHTML = out;
}