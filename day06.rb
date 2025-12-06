# --- Day 6: Trash Compactor ---

# After helping the Elves in the kitchen, you were taking a break and helping them re-enact a
# movie scene when you over-enthusiastically jumped into the garbage chute!
#
# A brief fall later, you find yourself in a garbage smasher. Unfortunately, the door's been
# magnetically sealed.
#
# As you try to find a way out, you are approached by a family of cephalopods! They're pretty sure
# they can get the door open, but it will take some time. While you wait, they're curious if you
# can help the youngest cephalopod with her math homework.
#
# Cephalopod math doesn't look that different from normal math. The math worksheet (your puzzle
# input) consists of a list of problems; each problem has a group of numbers that need to either
# be either added (+) or multiplied (*) together.
#
# However, the problems are arranged a little strangely; they seem to be presented next to each
# other in a very long horizontal list. For example:
#
# 123 328  51 64
#  45 64  387 23
#   6 98  215 314
# *   +   *   +
#
# Each problem's numbers are arranged vertically; at the bottom of the problem is the symbol for
# the operation that needs to be performed. Problems are separated by a full column of only
# spaces. The left/right alignment of numbers within each problem can be ignored.
#
# So, this worksheet contains four problems:
#
#
# 123 * 45 * 6 = 33210
# 328 + 64 + 98 = 490
# 51 * 387 * 215 = 4243455
# 64 + 23 + 314 = 401
#
# To check their work, cephalopod students are given the grand total of adding together all of the
# answers to the individual problems. In this worksheet, the grand total is 33210 + 490 + 4243455
# + 401 = 4277556.
#
# Of course, the actual worksheet is much wider. You'll need to make sure to unroll it completely
# so that you can read the problems clearly.
#
# Solve the problems on the math worksheet. What is the grand total found by adding together all
# of the answers to the individual problems?
#

# --- Part Two ---

# The big cephalopods come back to check on how things are going. When they see that your grand
# total doesn't match the one expected by the worksheet, they realize they forgot to explain how
# to read cephalopod math.

# Cephalopod math is written right-to-left in columns. Each number is given in its own column,
# with the most significant digit at the top and the least significant digit at the
# bottom. (Problems are still separated with a column consisting only of spaces, and the symbol at
# the bottom of the problem is still the operator to use.)

# Here's the example worksheet again:

# 123 328  51 64 
#  45 64  387 23 
#   6 98  215 314
# *   +   *   +  
# Reading the problems right-to-left one column at a time, the problems are now quite different:

# The rightmost problem is 4 + 431 + 623 = 1058
# The second problem from the right is 175 * 581 * 32 = 3253600
# The third problem from the right is 8 + 248 + 369 = 625
# Finally, the leftmost problem is 356 * 24 * 1 = 8544
# Now, the grand total is 1058 + 3253600 + 625 + 8544 = 3263827.

# Solve the problems on the math worksheet again. What is the grand total found by adding together
# all of the answers to the individual problems?

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
  123 328  51 64 
   45 64  387 23 
    6 98  215 314
  *   +   *   +  
  END
  expected = 4277556
  expected2 = 3263827
else
  puts "solving day #{day} from input"
end

operands = []
operations = []

coperands = []
cfinal = [[]]
part1 = 0
part2 = 0
input.each_line(chomp: true) do |line|
  puts line if debugging
  stuff = line.strip.split(' ')
  if stuff.first.match?(/\d/)
    operands << stuff.map(&:to_i)
    # if coperands.empty?
    #   coperands = Array.new(line.length) { "" }
    #   p coperands if debugging
    # end
    # line.each_char.with_index do |chr,idx|
    #   coperands[idx] << chr
    # end
    coperands << line.chars
  else
    operations = stuff.map(&:to_sym)
    coperands.transpose.map(&:join).each do |op|
      if (x = op.strip).empty?
        cfinal << []
      else
        cfinal.last << x.to_i
      end
    end
    break
  end
end

operands.transpose.each.with_index do |ops, idx|
  if debugging
    puts ops.inspect, operations[idx]
  end
  part1 += ops.reduce(operations[idx])
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

operations.each.with_index do |op,idx|
  part2 += cfinal[idx].reduce(op)
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
