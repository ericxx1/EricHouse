require 'curses'
include Curses
 
def draw this
  Curses.setpos 0, 0
  Curses.addstr this
  Curses.refresh
  sleep 0.2
end
def player
addstr("(*_*)")
end
def animation
  draw '(*_*)-|--|-'
  draw '(/*_*)-|--|-'
  draw '(/*_*/) -|--|-'
  draw '(/*_*)/  _|__|_'
  draw '(/*_*)/ ~ _|__|_'
  draw '(/*_*)/ ~   _|__|_'
  draw '(*_*)/       _|__|_'
  draw '\(*_*)/      _|__|_'
  draw '/(*_*)/      _|__|_'
  draw '\(*_*)/      _|__|_'
end
def gettable 
  draw '  \(*_*)     _|__|_'
  draw '    (*_*)\   _|__|_'
  draw '     (*_*)   _|__|_'
  draw '       (*_*) _|__|_'
  draw '        (*_*)_|__|_'
  draw '             _|__|_(*_*)'
  draw '             _|__|_(*_*\)'
  draw '            -|--|-\(*_*\)'
  draw '        -|--|- ~ \(*_*\) '
  draw '      -|--|-  (*_*\)     '
  draw '     -|--|-  (*_*\)      '
  draw '(*_*)-|--|-              '
end  
def table
table = addstr("-|--|-")
end
def flipped
flipped = addstr("_|__|_")
end
puts "What would u like to do: flip or get"
loop do
com = gets.chomp
if com == "flip"
animation
Curses.refresh
elsif com == "get"
gettable
end
end
