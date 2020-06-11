require './game'
def play_round(file_name,game)
  puts "------------------Hangman-------------------"
  puts game.display.join
  print "\n"
  
  loop do
    puts"-----Do you wanna save the game------: y/n"
    save_game = gets.chomp
    game.tries += 1
    if save_game.eql?("y")
      File.open("Saves/#{file_name}","w") do |saved_file| 
        saved_file.puts game.to_json
      end
    end
  
    puts "----Guess a letter or the complete word----"
    guess = gets.chomp.downcase
    if guess.size === 1
      game.secret_word.split("").each_with_index { |letter, index| game.display[index] = guess if guess.eql?(letter) }
    else
      game.display = game.secret_word.split("") if guess.eql?(game.secret_word.split(""))    
    end
  
    puts game.display.join
    print "\n"
    won = false
    game.display.eql?(game.secret_word.split(""))? won = true : won = false
  
    if won === true || game.tries === 6
      puts "You Win" if won.eql?(true)
      puts "You lose!" if won.eql?(false)
      break
    else
      guesses_left = 6 - game.tries
      puts "you have #{guesses_left} tr#{guesses_left === 1 ? "y" : "ies"} left"
    end
  end
  
end

puts"-----Open one of your saved games?-------y/n"
open_saved_game = gets.chomp
if open_saved_game.eql?("y")
  puts Dir.glob('Saves/*.{txt}').join(",\n")
  puts "choose a file e.g save5.txt"
  file_name = gets.chomp
  if File.exists?("Saves/#{file_name}")
    contents = File.open("Saves/#{file_name}", "r"){ |file| file.read }
    game = Game.from_json(contents)
    play_round(file_name,game) unless game.tries >= 6
    puts "the correct word is : " + game.secret_word
  else
    puts "No such file"    
  end
else
  game = Game.new("",[], 0)
  game.choose_secret_word
  game.secret_word.size.times{ game.display.push("_ ") }
  save_number = Dir.glob('Saves/*').length
  file_name = "save#{save_number}.txt"
  play_round(file_name,game)
  puts "the correct word is : " + game.secret_word
end