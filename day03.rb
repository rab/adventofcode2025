# --- Day 3: Lobby ---

# You descend a short staircase, enter the surprisingly vast lobby, and are quickly cleared by the
# security checkpoint. When you get to the main elevators, however, you discover that each one has
# a red light above it: they're all offline.
#
# "Sorry about that," an Elf apologizes as she tinkers with a nearby control panel. "Some kind of
# electrical surge seems to have fried them. I'll try to get them online soon."
#
# You explain your need to get further underground. "Well, you could at least take the escalator
# down to the printing department, not that you'd get much further than that without the elevators
# working. That is, you could if the escalator weren't also offline."
#
# "But, don't worry! It's not fried; it just needs power. Maybe you can get it running while I
# keep working on the elevators."
#
# There are batteries nearby that can supply emergency power to the escalator for just such an
# occasion. The batteries are each labeled with their joltage rating, a value from 1 to 9. You
# make a note of their joltage ratings (your puzzle input). For example:
#
# 987654321111111
# 811111111111119
# 234234234234278
# 818181911112111
#
# The batteries are arranged into banks; each line of digits in your input corresponds to a single
# bank of batteries. Within each bank, you need to turn on exactly two batteries; the joltage that
# the bank produces is equal to the number formed by the digits on the batteries you've turned
# on. For example, if you have a bank like 12345 and you turn on batteries 2 and 4, the bank would
# produce 24 jolts. (You cannot rearrange batteries.)
#
# You'll need to find the largest possible joltage each bank can produce. In the above example:
#
#
# In 987654321111111, you can make the largest joltage possible, 98, by turning on the first two batteries.
# In 811111111111119, you can make the largest joltage possible by turning on the batteries
#                     labeled 8 and 9, producing 89 jolts.
# In 234234234234278, you can make 78 by turning on the last two batteries (marked 7 and 8).
# In 818181911112111, the largest joltage you can produce is 92.
#
# The total output joltage is the sum of the maximum joltage from each bank, so in this example,
# the total output joltage is 98 + 89 + 78 + 92 = 357.
#
# There are many batteries in front of you. Find the maximum joltage possible from each bank; what
# is the total output joltage?
#

# --- Part Two ---

# The escalator doesn't move. The Elf explains that it probably needs more joltage to overcome the
# static friction of the system and hits the big red "joltage limit safety override" button. You
# lose count of the number of times she needs to confirm "yes, I'm sure" and decorate the lobby a
# bit while you wait.

# Now, you need to make the largest joltage by turning on exactly twelve batteries within each
# bank.

# The joltage output for the bank is still the number formed by the digits of the batteries you've
# turned on; the only difference is that now there will be 12 digits in each bank's joltage output
# instead of two.

# Consider again the example from before:

# 987654321111111
# 811111111111119
# 234234234234278
# 818181911112111

# Now, the joltages are much larger:

# In 987654321111111, the largest joltage can be found by turning on everything except some 1s at
# the end to produce 987654321111.

# In the digit sequence 811111111111119, the largest joltage can be found by turning on everything
# except some 1s, producing 811111111119.

# In 234234234234278, the largest joltage can be found by turning on everything except a 2
# battery, a 3 battery, and another 2 battery near the start to produce 434234234278.

# In 818181911112111, the joltage 888911112111 is produced by turning on everything except some 1s
# near the front.

# The total output joltage is now much larger: 987654321111 + 811111111119 + 434234234278 +
# 888911112111 = 3121910778619.

# What is the new total output joltage?

require_relative 'input'

bold = `tput bold`
norm = `tput sgr0`

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2025)

while ARGV[0]
  case ARGV.shift
  when 'test'
    testing = true
  when 'debug'
    debugging = true
  end
end

if testing
  input = <<~END
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  END
  expected = 357
  expected2 = 3121910778619
else
  puts "solving day #{day} from input"
end

def joltage(batteries, digits: 2, testing: false, debugging: false)

  puts "From: %s"%[batteries.join] if debugging

  batt_size = batteries.size
  result = 0
  unit_pos = -1
  1.upto(digits) do |digit|
    print "digit: #{digit} " if debugging
    unit_pos += 1
    print "starting: #{unit_pos} " if debugging
    remaining = digits - digit  # number of remaining digits to reserve
    print "remaining: #{remaining} " if debugging
    unit = batteries[unit_pos,(batt_size - unit_pos - remaining)].max
    print "finds #{unit} at #{ batteries[unit_pos..(batt_size - remaining)].index(unit) }" if debugging
    unit_pos += batteries[unit_pos,(batt_size - unit_pos - remaining)].index(unit)

    result *= 10
    result += unit
    puts " (currently #{result})" if debugging
  end

  result
end

part1 = 0
part2 = 0
input.each_line(chomp: true) do |line|
  puts line if debugging
  batteries = line.chars.map(&:to_i)
  batt_size = batteries.size

  # tens = batteries[0..-2].max
  # tens_pos = batteries.index(tens)

  # ones = batteries[tens_pos+1..-1].max
  # ones_pos = batteries.rindex(ones)
  # if debugging
  #   print batteries[0..tens_pos-1].join unless tens_pos.zero?
  #   print bold + batteries[tens_pos].to_s + norm
  #   print batteries[tens_pos+1..ones_pos-1].join unless tens_pos+1 == ones_pos
  #   print bold + batteries[ones_pos].to_s + norm
  #   print batteries[ones_pos+1..-1].join unless ones_pos+1 == batt_size
  #   puts
  # end

  # voltage = tens * 10 + ones
  # part1 += voltage

  # puts "old: %2d  %2d :new"%[voltage, joltage(batteries, testing:, debugging:)] if debugging
  part1 += joltage(batteries, digits:  2, testing:, debugging:)
  part2 += joltage(batteries, digits: 12, testing:, debugging:)
end

puts "Part 1: ", part1
if testing && expected
  if expected == part1
    puts "GOOD"
  else
    puts "Expected #{expected}"
    exit 1
  end
end

puts "Part 2: ", part2
if testing && expected2
  if expected2 == part2
    puts "GOOD"
  else
    puts "Expected #{expected2}"
    exit 1
  end
end
