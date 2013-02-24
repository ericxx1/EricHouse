require 'curses'
 
def draw this
  Curses.setpos 0, 0
  Curses.addstr this
  Curses.refresh
  sleep 0.4
end
puts "Type throw to toss a spear:"
yes = gets.chomp
if yes = "throw" 
draw '(*_*)'
draw '(/*_*)'
draw '(/*_*/)----->                |_._|;>'
draw '(/*_*)/  ------>'
draw '(/*_*)/       ------->       |_._|;>'
draw '(/*_*)/ ~            ------->|_._|;>'
draw '(*_*)/                       ---|_+=._|;>'
draw '\(*_*)/       	              :-.-'-';.>"'
draw '/(*_*)/ Woot Woot!'
draw '\(*_*)/ I win!'
draw '\(*_*)\ Points +1'
end
