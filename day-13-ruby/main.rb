
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
    time_until_bus = (Integer(bus) - (part_2 % Integer(bus)))
    offset_required = (offs % Integer(bus))
    # we need: the time until the bus arrives is the proper offset
    # the way we calculate the time until the bus arrives, it might be equal to the bus' ID
    # we need to catch this case to prevent an infinite loop
    while time_until_bus != offset_required && !(offset_required == 0 && (part_2 % Integer(bus)) == 0)
      # we can't mess up the results for the previous buses, so we need to add the accumulate
      part_2 += acc 

      # calculate the new time until the bus arrives with the new accumulated time stamp
      time_until_bus = (Integer(bus) - (part_2 % Integer(bus)))
    end
    acc *= Integer(bus)
  end
  offs += 1
}
puts(part_2)
