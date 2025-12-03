# --- Day 1: Secret Entrance ---
# The Elves have good news and bad news.
#
# The good news is that they've discovered project management! This has given them the tools they
# need to prevent their usual Christmas emergency. For example, they now know that the North Pole
# decorations need to be finished soon so that other critical tasks can start on time.
#
# The bad news is that they've realized they have a different emergency: according to their
# resource planning, none of them have any time left to decorate the North Pole!
#
# To save Christmas, the Elves need you to finish decorating the North Pole by December 12th.
#
# Collect stars by solving puzzles.  Two puzzles will be made available on each day; the second
# puzzle is unlocked when you complete the first.  Each puzzle grants one star. Good luck!
#
# You arrive at the secret entrance to the North Pole base ready to start
# decorating. Unfortunately, the password seems to have been changed, so you can't get in. A
# document taped to the wall helpfully explains:
#
# "Due to new security protocols, the password is locked in the safe below. Please see the
# attached document for the new combination."
#
# The safe has a dial with only an arrow on it; around the dial are the numbers 0 through 99 in
# order. As you turn the dial, it makes a small click noise as it reaches each number.
#
# The attached document (your puzzle input) contains a sequence of rotations, one per line, which
# tell you how to open the safe. A rotation starts with an L or R which indicates whether the
# rotation should be to the left (toward lower numbers) or to the right (toward higher
# numbers). Then, the rotation has a distance value which indicates how many clicks the dial
# should be rotated in that direction.
#
# So, if the dial were pointing at 11, a rotation of R8 would cause the dial to point at 19. After
# that, a rotation of L19 would cause it to point at 0.
#
# Because the dial is a circle, turning the dial left from 0 one click makes it point at
# 99. Similarly, turning the dial right from 99 one click makes it point at 0.
#
# So, if the dial were pointing at 5, a rotation of L10 would cause it to point at 95. After that,
# a rotation of R5 could cause it to point at 0.
#
# The dial starts by pointing at 50.
#
# You could follow the instructions, but your recent required official North Pole secret entrance
# security training seminar taught you that the safe is actually a decoy. The actual password is
# the number of times the dial is left pointing at 0 after any rotation in the sequence.
#
# For example, suppose the attached document contained the following rotations:
#
# L68
# L30
# R48
# L5
# R60
# L55
# L1
# L99
# R14
# L82
#
# Following these rotations would cause the dial to move as follows:
#
#
# The dial starts by pointing at 50.
# The dial is rotated L68 to point at 82.
# The dial is rotated L30 to point at 52.
# The dial is rotated R48 to point at 0.
# The dial is rotated L5 to point at 95.
# The dial is rotated R60 to point at 55.
# The dial is rotated L55 to point at 0.
# The dial is rotated L1 to point at 99.
# The dial is rotated L99 to point at 0.
# The dial is rotated R14 to point at 14.
# The dial is rotated L82 to point at 32.
#
# Because the dial points at 0 a total of three times during this process, the password in this example is 3.
#
# Analyze the rotations in your attached document. What's the actual password to open the door?
#

# --- Part Two ---
#
# You're sure that's the right password, but the door won't open. You knock, but nobody
# answers. You build a snowman while you think.

# As you're rolling the snowballs for your snowman, you find another security document that must
# have fallen into the snow:

# "Due to newer security protocols, please use password method 0x434C49434B until further notice."

# You remember from the training seminar that "method 0x434C49434B" means you're actually supposed
# to count the number of times any click causes the dial to point at 0, regardless of whether it
# happens during a rotation or at the end of one.

# Following the same rotations as in the above example, the dial points at zero a few extra times during its rotations:

# The dial starts by pointing at 50.
# The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
# The dial is rotated L30 to point at 52.
# The dial is rotated R48 to point at 0.
# The dial is rotated L5 to point at 95.
# The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
# The dial is rotated L55 to point at 0.
# The dial is rotated L1 to point at 99.
# The dial is rotated L99 to point at 0.
# The dial is rotated R14 to point at 14.
# The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.
#
# In this example, the dial points at 0 three times at the end of a rotation, plus three more
# times during a rotation. So, in this example, the new password would be 6.

# Be careful: if the dial were pointing at 50, a single rotation like R1000 would cause the dial
# to point at 0 ten times before returning back to 50!

# Using password method 0x434C49434B, what is the password to open the door?


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
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
END
  expected = 3
  expected2 = 6
else
  puts "solving day #{day} from input"
end

pointer = 50

part1 = 0
part2 = 0
input.each_line(chomp: true) do |line|
  puts line if debugging
  dir, count = line.match(/\A([LR])(\d+)\z/).captures
  count = count.to_i

  case dir
  when 'L'
    if count > pointer
      full, partial = count.divmod(100)
      part2 += full
      puts "#{full} full turns" if debugging && full.positive?
      if partial.positive? && pointer.nonzero? && partial > pointer
        part2 += 1
        puts "passing 0" if debugging
      end
    end
    pointer -= count
  when 'R'
    if count > (99 - pointer)
      full, partial = count.divmod(100)
      part2 += full
      puts "#{full} full turns" if debugging && full.positive?
      if partial.positive? && pointer.nonzero? && pointer + partial > 100
        part2 += 1
        puts "passing 0" if debugging
      end
    end

    pointer += count
  else
    warn "can't handle #{dir.inspect} from #{line}"
    exit
  end

  pointer %= 100                # %=

  if pointer.zero?
    puts "landed on zero" if debugging
    part1 += 1
    part2 += 1
  end
  puts "pointer is: #{pointer}" if debugging
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
