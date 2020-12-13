
File.open("input.txt", "r") do |f|
  $time = Integer(f.gets) # puts(f.gets)
  $buses = f.gets.split(",")
end

depart = -1 # no bus can be more than $time away
first = -1
$buses.each { |bus|
  if bus != "x"
    # time until bus leaves is bus - (time % bus)
    if first == -1 || (Integer(bus) - $time % Integer(bus)) < depart
      depart = Integer(bus) - ($time % Integer(bus))
      first = Integer(bus)
    end
  end
}
puts first * depart

# note: the input values are all primes
offs = 0 # offset (outcome for modulo)
acc = 1 # accumulated product of primes so far
part_2 = 0
$buses.each { |bus|
  if bus != "x"
    while (Integer(bus) - (part_2 % Integer(bus))) != (offs % Integer(bus)) && !(offs % Integer(bus) == 0 && (part_2 % Integer(bus)) == 0)
      part_2 += acc
    end
    acc *= Integer(bus)
  end
  offs += 1
}
puts(part_2)