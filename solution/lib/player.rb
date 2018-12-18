require "byebug"

class Player

  attr_accessor :nodes_visited
  attr_reader :game, :name, :start_time

  def initialize(game, name = "Bill Gates")
    @game = game
    @name = name
    @nodes_visited = 0
    @start_time = Time.now()
  end

  def take_turn
    begin
      from_pile = game.map[get_from_pile.ord]
      to_pile = game.map[get_to_pile.ord]
      to_pile.valid_add?(from_pile.peek)
      to_pile.add!(from_pile.pop)
      self.nodes_visited = nodes_visited + 1
    rescue => e
      puts e.message
      retry
    end
  end

  def end_game(print_nodes)
    end_time = Time.now()
    puts "Took #{end_time - start_time} seconds"
    puts "Visited #{nodes_visited} nodes"
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
