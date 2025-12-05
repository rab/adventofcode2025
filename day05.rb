# --- Day 5: Cafeteria ---

# As the forklifts break through the wall, the Elves are delighted to discover that there was a
# cafeteria on the other side after all.
#
# You can hear a commotion coming from the kitchen. "At this rate, we won't have any time left to
# put the wreaths up in the dining hall!" Resolute in your quest, you investigate.
#
# "If only we hadn't switched to the new inventory management system right before Christmas!"
# another Elf exclaims. You ask what's going on.
#
# The Elves in the kitchen explain the situation: because of their complicated new inventory
# management system, they can't figure out which of their ingredients are fresh and which are
# spoiled. When you ask how it works, they give you a copy of their database (your puzzle input).
#
# The database operates on ingredient IDs. It consists of a list of fresh ingredient ID ranges, a
# blank line, and a list of available ingredient IDs. For example:
#
# 3-5
# 10-14
# 16-20
# 12-18
#
# 1
# 5
# 8
# 11
# 17
# 32
#
# The fresh ID ranges are inclusive: the range 3-5 means that ingredient IDs 3, 4, and 5 are all
# fresh. The ranges can also overlap; an ingredient ID is fresh if it is in any range.
#
# The Elves are trying to determine which of the available ingredient IDs are fresh. In this
# example, this is done as follows:
#
# Ingredient ID 1 is spoiled because it does not fall into any range.
# Ingredient ID 5 is fresh because it falls into range 3-5.
# Ingredient ID 8 is spoiled.
# Ingredient ID 11 is fresh because it falls into range 10-14.
# Ingredient ID 17 is fresh because it falls into range 16-20 as well as range 12-18.
# Ingredient ID 32 is spoiled.
#
# So, in this example, 3 of the available ingredient IDs are fresh.
#
# Process the database file from the new inventory management system. How many of the available
# ingredient IDs are fresh?
#

require_relative 'input'

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
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  END
  expected = 3
  expected2 = nil
else
  puts "solving day #{day} from input"
end

part1 = 0
part2 = nil

ranges = []
ingredients = []

stage = :ranges

input.each_line(chomp: true) do |line|
  puts line if debugging
  if line.empty?
    stage = :ingredients
    next
  end

  case stage
  when :ranges
    ranges << Range.new(* line.split('-').map(&:to_i))
  when :ingredients
    ingredients << line.to_i
  end
end

part1 = ingredients.count {|i| ranges.any? {|r| r.include? i} }

reduced = []
ranges.sort_by { [_1.begin, _1.end] }.each {|range|
  if reduced.empty?
    reduced << range
    next
  end
  if reduced.last.overlap? range
    reduced[-1] = (reduced.last.begin .. [reduced.last.end, range.end].max)
  else
    reduced << range
  end
}

p reduced if debugging

part2 = reduced.map(&:size).sum

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
