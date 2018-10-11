require "byebug"

class Player

  attr_reader :game, :name

  def initialize(game, name = "Bill Gates")

  end

  def take_turn
    begin
      from_pile = game.map[get_from_pile.ord]
      to_pile = game.map[get_to_pile.ord]
      card = from_pile.pop
      to_pile.add(card)
    rescue => e
      from_pile.add!(card)
      puts e.message
      retry
    end
  end

  private

  ACCEPTABLE_FROM = ("0".."7").to_a + ("a".."d").to_a
  ACCEPTABLE_TO = ACCEPTABLE_FROM + ("w".."z").to_a

  def get_from_pile
    begin
      print "Take from which pile? "
      input = gets.chomp
      raise unless ACCEPTABLE_FROM.include?(input)
    rescue
      puts "Please enter 0, 1, 2, 3, 4, 5, 6, 7, a, b, c, or d"
      retry
    end

    input
  end

  def get_to_pile
    begin
      print "Put onto which pile? "
      input = gets.chomp
      raise unless ACCEPTABLE_TO.include?(input)
    rescue
      puts "Please enter 0, 1, 2, 3, 4, 5, 6, 7, a, b, c, d, w, y, z, or z"
      retry
    end

    input
  end

end
