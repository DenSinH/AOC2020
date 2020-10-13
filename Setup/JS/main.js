"use strict";


function part1(input) {
    console.log(input);
    return input;
}


function part2(input) {
    console.log(input);
    return input;
}


function main() {
    let out = "";

    let radios = document.getElementsByName("part");
    if (radios[0].checked) {
        out = "Part 1:" + part1(document.getElementById("input").innerHTML);
    }
    else if (radios[1].checked) {
        out = "Part 2: " + part2(document.getElementById("input").innerHTML);
    }
    else {
        out = "Select a part";
    }
    document.getElementById("solution").innerHTML = out;
}