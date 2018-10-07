require_relative "deck"
require_relative "tableau"
require_relative "freecell"
require_relative "foundation"
require_relative "display"
require_relative "player"

class Game

  attr_reader :display, :freecells, :foundations, :tableaus, :map, :player

  def initialize(deck = Deck.new)
    @tableaus = Array.new(8) { Tableau.new }
    @freecells = Array.new(4) { Freecell.new }
    @foundations = Card.suits.map { |suit| Foundation.new(suit) }
    @display = Display.new(self)
    @player = Player.new(self)
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

    puts "\n\n\nCRAZY CARD ANIMATION!!!\n\n\n"
  end

  def render
    # for display only
    display.render
  end

  def tableau_lengths
    # for display only
    tableaus.map { |tab| tab.length }
  end

  private

  def populate_tableaus(deck)
    deck.count.times { |i| @tableaus[i % tableaus.count].force_push(deck.pop) }
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
  g = Game.new
  g.play
end
