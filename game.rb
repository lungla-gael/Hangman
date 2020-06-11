require 'json'
class Game
    attr_accessor :display, :secret_word, :tries

    def initialize(secret_word, display, tries)
        @secret_word = secret_word
        @display = display
        @tries = tries
    end

    def choose_secret_word
        dictionary = []
        File.open("5desk.txt").readlines.each do |line|
          word = line.strip
          dictionary.push(word) if word.length > 4 && word.length < 13
        end
        self.secret_word = dictionary[rand(dictionary.size)].downcase 
    end

    def to_json
        JSON.dump ({
          :secret_word => @secret_word,
          :display => @display,
          :tries => @tries
        })
    end
    
    def self.from_json(string)
    data = JSON.load string
    self.new(data['secret_word'], data['display'], data['tries'])
    end
end