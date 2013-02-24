#!/usr/bin/env ruby

require 'curses'
include Curses

init_screen
curs_set(frame = 0)

Thread.new { system "say -v Alex the rofl copter says #{'siff ' * 1000}" }

while (frame += 1)
  [
    %|      4321043210LOL4321043210  |,
    %|                 ^             |,
    %|012     /-------------         |,
    %|3O3=======        [ ] \\        |,
    %|210       \\            \\       |,
    %|           \\____________]      |,
    %|              I     I          |,
    %|          --------------/      |
  ].each_with_index do |line, index|
    { 0 => [':LFOR', 5], (2..4) => ['L    ', 4] }.each do |key, (ch, n)|
      n.times { |i| line.tr!(i.to_s, ch.chars.to_a[(i + frame) % n]) } if key === index
    end

    copter = (line + (' ' * (cols - 31))).chars.to_a
    frame.times { copter.unshift(copter.pop) }

    setpos(5 + index, 0)
    addstr copter.join
  end

  refresh
  sleep 0.08
end

at_exit { close_screen }
