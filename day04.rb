# --- Day 4: Printing Department ---

# You ride the escalator down to the printing department. They're clearly getting ready for
# Christmas; they have lots of large rolls of paper everywhere, and there's even a massive printer
# in the corner (to handle the really big print jobs).
#
# Decorating here will be easy: they can make their own decorations. What you really need is a way
# to get further into the North Pole base while the elevators are offline.
#
# "Actually, maybe we can help with that," one of the Elves replies when you ask for help. "We're
# pretty sure there's a cafeteria on the other side of the back wall. If we could break through
# the wall, you'd be able to keep moving. It's too bad all of our forklifts are so busy moving
# those big rolls of paper around."
#
# If you can optimize the work the forklifts are doing, maybe they would have time to spare to
# break through the wall.
#
# The rolls of paper (@) are arranged on a large grid; the Elves even have a helpful diagram (your
# puzzle input) indicating where everything is located.
#
# For example:
#
# ..@@.@@@@.
# @@@.@.@.@@
# @@@@@.@.@@
# @.@@@@..@.
# @@.@@@@.@@
# .@@@@@@@.@
# .@.@.@.@@@
# @.@@@.@@@@
# .@@@@@@@@.
# @.@.@@@.@.
#
# The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the
# eight adjacent positions. If you can figure out which rolls of paper the forklifts can access,
# they'll spend less time looking and more time breaking down the wall to the cafeteria.
#
# In this example, there are 13 rolls of paper that can be accessed by a forklift (marked with x):
#
# ..xx.xx@x.
# x@@.@.@.@@
# @@@@@.x.@@
# @.@@@@..@.
# x@.@@@@.@x
# .@@@@@@@.@
# .@.@.@.@@@
# x.@@@.@@@@
# .@@@@@@@@.
# x.x.@@@.x.
#
# Consider your complete diagram of the paper roll locations. How many rolls of paper can be
# accessed by a forklift?

# --- Part Two ---

# Now, the Elves just need help accessing as much of the paper as they can.

# Once a roll of paper can be accessed by a forklift, it can be removed. Once a roll of paper is
# removed, the forklifts might be able to access more rolls of paper, which they might also be
# able to remove. How many total rolls of paper could the Elves remove if they keep repeating this
# process?

# Starting with the same example as above, here is one way you could remove as many rolls of paper
# as possible, using ø highlighted @ to indicate that a roll of paper is about to be removed, and
# using x to indicate that a roll of paper was just removed:

# Stop once no more rolls of paper are accessible by a forklift. In this example, a total of 43
# rolls of paper can be removed.

# Start with your original diagram. How many rolls of paper in total can be removed by the Elves
# and their forklifts?

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
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  END

  expected = 13
  expected2 = 43
else
  puts "solving day #{day} from input"
end

part1 = 0
part2 = 0
floor = []
input.each_line(chomp: true) do |line|
  # puts line if debugging
  floor << line.chars
end
puts floor.map(&:join) if debugging
p floor if debugging

def neighbors(row, col, rows:, cols:, testing:, debugging:)
  [ [-1,-1], [-1,0], [-1,1],
    [ 0,-1],         [ 0,1],
    [ 1,-1], [ 1,0], [ 1,1],
  ].each do |(r,c)|
    next if row + r < 0 || row + r >= rows
    next if col + c < 0 || col + c >= cols
    yield [row + r,col + c]
  end
end

def accessible(grid, limit:, testing:, debugging:)
  rows = grid.size
  cols = grid.first.size

  count = 0
  rows.times do |row|
    cols.times do |col|
      next if grid[row][col] == '.'
      n = 0
      puts "[%d,%d]"%[row,col] if debugging
      neighbors(row, col, rows:, cols:, testing:, debugging:) do |r,c|
        puts "  [%d,%d] %s"%[r,c,grid[r][c]] if debugging
        n += 1 if grid[r][c] != '.'
      end
      grid[row][col] = n.to_s
      if n < limit
        count += 1
      end
    end
  end

  count
end

# assumes grid has . (empty) or [1-8] (paper with that many neighbors)
# returns [count, newgrid]
def remove(grid, limit:, testing:, debugging:)
  rows = grid.size
  cols = grid.first.size

  count = 0                     # how many get removed
  rows.times do |row|
    cols.times do |col|
      next if grid[row][col] == '.'
      if grid[row][col].to_i < limit
        count += 1
        grid[row][col] = 'x'
      end
    end
  end

  rows.times do |row|
    cols.times do |col|
      next unless grid[row][col] == 'x'
      grid[row][col] = '.'
      neighbors(row, col, rows:, cols:, testing:, debugging:) do |r,c|
        next if grid[r][c].to_i.zero?
        grid[r][c] = (grid[r][c].to_i - 1).to_s
      end
    end
  end

  [count, grid]
end

part1 = accessible(floor, limit: 4, testing:, debugging:)
puts floor.map(&:join) if debugging
while (moved, newgrid = remove(floor, limit: 4, testing:, debugging:)) && moved.nonzero?
  part2 += moved
  floor = newgrid
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
