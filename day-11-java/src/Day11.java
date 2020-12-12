import java.io.*;
import java.util.*;

public class Day11 {

    public static int occupied_around(int i, int j, ArrayList<char[]> seats) {
        int count = 0;
        for (int di = -1; di <= 1; di++) {
            for (int dj = -1; dj <= 1; dj++) {
                if ((di | dj) == 0) {
                    // the chair itself
                    continue;
                }

                if (i + di >= 0 && i + di < seats.size()) {
                    char[] row = seats.get(i + di);
                    if (j + dj >= 0 && j + dj < row.length) {
                        if (row[j + dj] == '#') {
                            // occupied seat found
                            count++;
                        }
                    }
                }
            }
        }
        return count;
    }

    public static int occupied_around_p2(int i, int j, ArrayList<char[]> seats) {
        int count = 0;
        for (int[] dir : new int[][]{{-1, -1}, {-1, 0}, {0, -1}, {1, 1}, {1, 0}, {0, 1}, {1, -1}, {-1, 1}}) {
            for (int dist = 1; true; dist++) {
                int di = dist * dir[0];
                int dj = dist * dir[1];

                if (i + di >= 0 && i + di < seats.size()) {
                    char[] row = seats.get(i + di);
                    if (j + dj >= 0 && j + dj < row.length) {
                        if (row[j + dj] == '#') {
                            count++;

                            // seat found, break line of sight
                            break;
                        }
                        else if (row[j + dj] == 'L') {
                            // seat found, break line of sight
                            break;
                        }
                    }
                    else {
                        // end of field reached
                        break;
                    }
                }
                else {
                    // end of field reached
                    break;
                }
            }
        }

        return count;
    }

    public static ArrayList<char[]> copy(ArrayList<char[]> seats) {
        ArrayList<char[]> new_seats = new ArrayList<>();
        for (char[] row : seats) {
            char[] new_row = row.clone();
            new_seats.add(new_row);
        }
        return new_seats;
    }

    public static int count_occupied(ArrayList<char[]> seats) {
        int count = 0;
        for (char[] row : seats) {
            for (char c : row) {
                count += c == '#' ? 1 : 0;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        ArrayList<char[]> seats = new ArrayList<>();

        // read input to an arraylist of char arrays
        try {
            File file = new File("input.txt");
            Scanner scanner = new Scanner(file);
            while (scanner.hasNextLine()) {
                seats.add(scanner.nextLine().toCharArray());
            }
        }
        catch (FileNotFoundException e) {
            System.out.println("Could not read input file");
            return;
        }

        // save original input for part 2
        ArrayList<char[]> original_input = copy(seats);

        boolean seat_changed;
        ArrayList<char[]> next_seats = copy(seats);
        ArrayList<char[]> temp;
        do {
            seat_changed = false;
            for (int i = 0; i < seats.size(); i++) {
                char[] row = seats.get(i);
                for (int j = 0; j < row.length; j++) {
                    if (row[j] == 'L') {
                        // empty chair, check if any occupied chairs around
                        if (occupied_around(i, j, seats) == 0) {
                            next_seats.get(i)[j] = '#';
                            seat_changed = true;
                            continue;
                        }
                    }
                    else if (row[j] == '#') {
                        if (occupied_around(i, j, seats) >= 4) {
                            next_seats.get(i)[j] = 'L';
                            seat_changed = true;
                            continue;
                        }
                    }
                    // copy unchanged square
                    next_seats.get(i)[j] = seats.get(i)[j];
                }
            }

            // swap references
            temp = seats;
            seats = next_seats;
            next_seats = temp;
        } while(seat_changed);

        System.out.format("Part 1: %d\n", count_occupied(seats));

        // part 2 is basically the same but with some extra rules
        seats = copy(original_input);
        do {
            seat_changed = false;
            for (int i = 0; i < seats.size(); i++) {
                char[] row = seats.get(i);
                for (int j = 0; j < row.length; j++) {
                    if (row[j] == 'L') {
                        // empty chair, check if any occupied chairs around
                        if (occupied_around_p2(i, j, seats) == 0) {
                            next_seats.get(i)[j] = '#';
                            seat_changed = true;
                            continue;
                        }
                    }
                    else if (row[j] == '#') {
                        if (occupied_around_p2(i, j, seats) >= 5) {
                            next_seats.get(i)[j] = 'L';
                            seat_changed = true;
                            continue;
                        }
                    }
                    next_seats.get(i)[j] = seats.get(i)[j];
                }
            }
            temp = seats;
            seats = next_seats;
            next_seats = temp;
        } while(seat_changed);

        System.out.format("Part 2: %d\n", count_occupied(seats));
    }

}
