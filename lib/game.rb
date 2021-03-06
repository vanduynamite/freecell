require_relative "requirements"

class Game

  attr_accessor :freecells, :foundations, :tableaus
  attr_reader :display, :map, :player, :reverse_map

  def initialize(human_player = false, deck = Deck.new)
    @tableaus = Array.new(8) { Tableau.new }
    @freecells = Array.new(4) { Freecell.new }
    @foundations = Card.suits.map { |suit| Foundation.new(suit) }
    populate_tableaus(deck)

    @display = Display.new(self)
    @map = create_map

    @human_player = human_player
    @player = human_player ? Player.new(self) : @player = AIPlayer.new(self)
  end

  def won?
    tableaus.all? { |tab| tab.empty? } && freecells.all? { |fc| fc.empty? }
  end

  def play
    render
    sleep(1)

    until won?
      render # comment this out for a faster solve and no display
      player.take_turn
    end

    end_game
  end

  def end_game
    render
    puts "\n\nYou won!!\n\n\n"
    return player.end_game
  end

  def render
    display.render
  end

  def tableau_lengths
    tableaus.map { |tab| tab.length }
  end

  def impossible(game_node)
    self.tableaus = game_node.tableaus
    self.freecells = game_node.freecells
    self.foundations = game_node.foundations
    render
    puts "Turns out this game is impossible to solve!"
  end

  private

  def populate_tableaus(deck)
    deck.count.times { |i| @tableaus[i % tableaus.count].add!(deck.pop) }
  end

  def create_map
    {
      48 => @tableaus[0],
      49 => @tableaus[1],
      50 => @tableaus[2],
      51 => @tableaus[3],
      52 => @tableaus[4],
      53 => @tableaus[5],
      54 => @tableaus[6],
      55 => @tableaus[7],
      97 => @freecells[0],
      98 => @freecells[1],
      99 => @freecells[2],
      100 => @freecells[3],
      119 => @foundations[0],
      120 => @foundations[1],
      121 => @foundations[2],
      122 => @foundations[3],
    }
  end

end

if __FILE__ == $0
  avg_nodes = 0
  results = []
  iterations = 1

  (0...iterations).each do |_|
    g = Game.new(false)
    results << g.play
    avg_nodes += results[-1][1]
  end

  puts "Average of #{avg_nodes / iterations} nodes visited across #{iterations} iterations\n\n"
  results.each_with_index do |r, i|
    puts "Iteration #{i + 1}:"
    puts "   Nodes Found:       #{r[0]}"
    puts "   Nodes Visited:     #{r[1]}"
    puts "   Depth of Solution: #{r[2]}"
    puts
  end
end
