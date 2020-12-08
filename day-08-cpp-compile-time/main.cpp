#include <cstdio>
#include <vector>
#include <array>

struct s_op {
    int opcode = 0;
    int arg    = 0;
};

#define op_nop 0
#define op_acc 1
#define op_jmp 2

#define nop },{ op_nop,
#define acc },{ op_acc,
#define jmp },{ op_jmp,

// note: doing this, the first opcode is {}
static constexpr s_op program[] = {
        {
#include "input.txt"
        }
};

static constexpr int part_1 = []{
    std::array<bool, sizeof(program)> repeated = {};
    for (int i = 0; i < sizeof(program); i++) {
        repeated[i] = false;
    }

    int pc = 1;
    int ac = 0;
    s_op op;

    while (true) {
        if (repeated[pc]) {
            break;
        }
        else {
            repeated[pc] = true;
        }

        op = program[pc];

        switch (op.opcode) {
            case op_nop:
                pc++;
                break;
            case op_acc:
                ac += op.arg;
                pc++;
                break;
            case op_jmp:
                pc += op.arg;
                break;
        }
    }

    return ac;
}();

static constexpr int part_2 = []{
    std::array<bool, sizeof(program)> repeated = {};

    for (int corrupt = 1; corrupt < sizeof(program) / sizeof(s_op); corrupt++) {
        if (program[corrupt].opcode == op_acc) {
            // not corrupt
            continue;
        }

        // reset
        for (int i = 0; i < sizeof(program); i++) {
            repeated[i] = false;
        }

        int pc = 1;
        int ac = 0;
        s_op op;

        while (true) {
            if (pc == sizeof(program) / sizeof(s_op)) {
                return ac;
            }

            if (repeated[pc]) {
                break;
            }
            else {
                repeated[pc] = true;
            }

            op = program[pc];
            if (pc == corrupt) {
                if (op.opcode == op_nop) {
                    op.opcode = op_jmp;
                }
                else {
                    op.opcode = op_nop;
                }
            }

            switch (op.opcode) {
                case op_nop:
                    pc++;
                    break;
                case op_acc:
                    ac += op.arg;
                    pc++;
                    break;
                case op_jmp:
                    pc += op.arg;
                    break;
            }
        }
    }
    return 0;
}();

int main() {
    printf("part 1: %d\n", part_1);
    printf("part 2: %d\n", part_2);
    return 0;
}
