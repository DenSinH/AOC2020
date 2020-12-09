module AOCDay9;

import std.stdio;
import std.conv;
import std.string;

int main()
{
    auto f = new File("./input.txt");
    string buffer;
    ulong[] numbers;

    // read input as ulong's
    int i = 0;
    foreach (line ; f.byLine) {
        buffer ~= line;
        buffer = strip(buffer);

        if (i >= numbers.length) {
            numbers.length = 2 * (i + 1);
		}

		numbers[i++] = parse!ulong(buffer);
	}
    numbers.length = i;

    // count times a number shows up as sum of 2 others in the previous 25 numbers
    const int batch_size = 25;
    int[ulong] count; 
    for (i = 0; i < batch_size; i++) {
        for (int j = i + 1; j < batch_size; j++) {
            ulong sum = numbers[i] + numbers[j];
            if (!(sum in count)) {
                count[sum] = 0;
			}

            count[sum] += 1;
		}
	}
    
    ulong invalid = 0;
    for (i = batch_size; i < numbers.length; i++) {
        if (!(numbers[i] in count && count[numbers[i]] > 0)) {
            invalid = numbers[i];
            break;
		}
        
        // remove sums coming from number batch_size ago
        // since for the next iteration, that number will be out of bounds
        // also add the new sums (coming from i and the numbers before it)
        for (int j = i - batch_size + 1; j < i; j++) {
            count[numbers[j] + numbers[i - batch_size]] -= 1;
            ulong sum = numbers[j] + numbers[i];
            if (!(sum in count)) {
                count[sum] = 0;
			}

            count[sum] += 1;
		}
	}
    
    assert(invalid > 0, "Failed to find part 1");
    
    ulong weakness = 0;
    for (i = 0; i < numbers.length; i++) {
        ulong sum = numbers[i];
        for (int j = i + 1; j < numbers.length; j++) {
            if (sum == invalid) {
                // found contiguous range of numbers summing to invalid
                ulong max = numbers[i];
				ulong min = numbers[i];
                for (int k = i; k < j; k++) {
                    if (numbers[k] > max) {
                        max = numbers[k];
					}
                    if (numbers[k] < min) {
					    min = numbers[k];
					}
				}
                weakness = min + max;
                goto part_2_done;
			}
            else if (sum > invalid) {
                break;
			}
            
            sum += numbers[j];
		}
	}
    part_2_done:

    writeln("Part 1: ", invalid);
    writeln("Part 2: ", weakness);
    readln();
    return 0;
}
