cmake_minimum_required(VERSION 3.19)
project(day_10_cmake)

file(READ "input.txt" input)

string(REGEX REPLACE ";" "\\\\;" input "${input}")
string(REGEX REPLACE "\n" ";" input ${input})

list(SORT input COMPARE NATURAL)

# add outlet of rating 0
list(PREPEND input 0)

# copy original input for part 2
set(original_input ${input})

list(LENGTH input input_len)

set(diff_1 0)
set(diff_3 1)  # final adapter always diff 3

while(input_len GREATER 1)

    list(POP_FRONT input adapter)
    list(GET input 0 next_adapter)

    math(EXPR diff "${next_adapter} - ${adapter}")

    if (diff EQUAL 1)
        math(EXPR diff_1 "${diff_1} + 1")
    elseif(diff EQUAL 3)
        math(EXPR diff_3 "${diff_3} + 1")
    endif()

    # message("${next_adapter} - ${adapter}")

    list(LENGTH input input_len)
endwhile()

math(EXPR part_1 "${diff_1} * ${diff_3}")
message("PART 1 = ${diff_1} * ${diff_3} = ${part_1}")

# idea for part 2:
# have a list of ways to connect to the outlet starting from adapter n
# the input doesn't seem to go insanely high, so I'd just need a list of length 200 or something
macro(LIST_REPLACE LIST INDEX NEWVALUE)
    list(INSERT ${LIST} ${INDEX} ${NEWVALUE})
    MATH(EXPR __INDEX "${INDEX} + 1")
    list (REMOVE_AT ${LIST} ${__INDEX})
endmacro(LIST_REPLACE)

# restore input
set(input ${original_input})

# allocate list
list(POP_BACK input max_adapter)
math(EXPR ways_to_connect_length "${max_adapter} + 1")
string(REPEAT "0\\;" ${ways_to_connect_length} ways_to_connect)
set(ways_to_connect ${ways_to_connect})

# now ways_to_connect is a list of length (max_adapter + 1) filled with 0s
LIST_REPLACE(ways_to_connect ${max_adapter} 1)

list(LENGTH input input_len)

while(input_len GREATER 0)

    # get highest adapter
    list(POP_BACK input adapter)

    set(adapter_connections 0)

    # get connections for adapter + 1 (might be 0)
    math(EXPR next_adapter "${adapter} + 1")
    list(GET ways_to_connect ${next_adapter} connections)
    math(EXPR adapter_connections "${adapter_connections} + ${connections}")

    # same for 2 and 3 away
    math(EXPR next_adapter "${adapter} + 2")
    if (NOT (next_adapter GREATER max_adapter))
        list(GET ways_to_connect ${next_adapter} connections)
        math(EXPR adapter_connections "${adapter_connections} + ${connections}")

        math(EXPR next_adapter "${adapter} + 3")
        if (NOT (next_adapter GREATER max_adapter))
            list(GET ways_to_connect ${next_adapter} connections)
            math(EXPR adapter_connections "${adapter_connections} + ${connections}")
        endif()
    endif()

    LIST_REPLACE(ways_to_connect ${adapter} ${adapter_connections})

    list(LENGTH input input_len)
endwhile()

list(GET ways_to_connect 0 total_connections)
message("PART 2 = ${total_connections}")