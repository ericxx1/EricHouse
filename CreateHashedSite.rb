def serial
  Array.new(20) do 
    [[*0..9].sample, [*'a'..'z'].sample, [*'a'..'z'].sample].sample
  end.join
end
 
puts 'Enter site name:'
site = gets.chomp 
puts 'Enter site extension:'
ext = gets.chomp
def add_word_to_serial word, insert_into
  original_length = insert_into.size
  word_length = word.size
  extra_space = original_length - word_length
  insert_into[rand(0..extra_space)..word_length] = word
  insert_into
end
 
puts add_word_to_serial site, serial + ext
