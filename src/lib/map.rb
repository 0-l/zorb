#!/usr/bin/env ruby
# encoding: UTF-8

require 'io/console'

class Map
  class << self
    def map size, row, column
      print "MAP %#{size-2}dx%d\n" % [column, row]

      axis = 1

      while axis != 10 do
        if axis == 1 || axis == 9
          print "+ #{'-' * size} +\n"
        elsif axis == row
          print "#{'|'.white.bg_gray} #{' ' * (column - 1) + "♦".red + ' ' * (size - column)} |\n"
        else
          print "| #{' ' * size} |\n"
        end
        axis += 1
      end
    end

    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e" then
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.cooked!

      return input
    end

    def show
      clear()

      pos      = 1
      map_size = 30
      y_axis   = 5
      x_axis   = map_size / 2

      map(map_size, y_axis, x_axis)

      while (y_axis != pos)
        char = read_char

        case char
        when "\u0003"
          exit 0
        when /^.$/
          if char == "s"
            y_axis += 1 unless y_axis >= 8
          elsif char == "w"
            y_axis -= 1 unless y_axis <= 2
          elsif char == "d"
            x_axis += 1 unless x_axis >= map_size
          elsif char == "a"
            x_axis -= 1 unless x_axis <= 1
          end

          clear() if y_axis != (pos - 1)
        end

        map(map_size, y_axis, x_axis)
        $stdout.flush
      end
    end
  end
end