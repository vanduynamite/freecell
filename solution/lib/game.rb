require_relative "requirements"

class Game

  attr_reader :display, :freecells, :foundations, :tableaus, :map, :player, :reverse_map

  def initialize(human_player = false, deck = Deck.new)
    @tableaus = Array.new(8) { Tableau.new }
    @freecells = Array.new(4) { Freecell.new }
    @foundations = Card.suits.map { |suit| Foundation.new(suit) }
    @display = Display.new(self)
    @human_player = human_player
    @player = human_player ? Player.new(self) : @player = AIPlayer.new(self)
    @map = create_map
    populate_tableaus(deck)
  end

  def won?
    tableaus.all? { |tab| tab.empty? } && freecells.all? { |fc| fc.empty? }
  end

  def play
    until won?
      render
      player.take_turn
    end

    end_game
  end

  def end_game
    render
    puts "\n\nYou won!!\n\n\n"
    # execute the shortest set of steps if AI
    exit
  end

  def render
    display.render
  end

  def tableau_lengths
    tableaus.map { |tab| tab.length }
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
  g = Game.new(false)
  g.play
end
