# To simplify starting a new day on the Advent of Code challenge.
#
# Prerequisite: the presence of the ./.session file containing the "session=19827364918273..."
#   value for the cookie.
#
# Returns the cached input or retrieves and caches the indicated day's input.
#
# Note that some days may not have an input file if the input was specified in the description.

require 'date'
require 'uri'
require 'http'

module Input
  extend self
  def for_day(day, year=Date.today.year)
    cache_file = 'day%02d_input.txt'%[day]
    if File.exist? cache_file
      File.read(cache_file)
    else
      uri = URI('https://adventofcode.com/%d/day/%s/input'%[year, day.to_s])
      cookies = File.read('./.session') if File.exist?('./.session')
      res = HTTP.cookies(Hash[* cookies.to_s.split(/=/,2)]).get(uri)
      res.body.to_s.tap {|contents| File.write(cache_file, contents) }
    end
  end
end
