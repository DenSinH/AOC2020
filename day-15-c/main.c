#include <stdio.h>
#include <memory.h>

int input[] = {
#include "input.txt"
};

typedef struct s_NumberData {
    int times_said;
    int prev_turn;
    int pre_prev_turn;
} s_NumberData;

s_NumberData said[30000000] = {};

int say_number(int number, int turn) {
    int next_number = 0;

    // say number
    said[number].pre_prev_turn = said[number].prev_turn;
    said[number].prev_turn = turn;
    said[number].times_said++;

    // find next number
    if (said[number].times_said > 1) {
        // number has been said before
        next_number = said[number].prev_turn - said[number].pre_prev_turn;
    }
    return next_number;
}

int main() {
    memset(said, 0, sizeof(said));
    int to_say = 0;

    // say input values
    int turn = 1;
    for (int i = 0; i < sizeof(input) / sizeof(int); i++) {
        to_say = say_number(input[i], turn);
        turn++;
    }

    // part 1
    while (turn < 2020) {
        to_say = say_number(to_say, turn);
        turn++;
    }
    printf("part 1: %d\n", to_say);

    // part 2
    while (turn < 30000000) {
        to_say = say_number(to_say, turn);
        turn++;
    }
    printf("part 2: %d\n", to_say);

    return 0;
}
