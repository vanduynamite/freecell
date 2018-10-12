require_relative "requirements"

class Game

  attr_reader :display, :freecells, :foundations, :tableaus, :map, :player, :reverse_map

  def initialize(deck = Deck.new)
    @tableaus = Array.new(8) { Tableau.new }
    @freecells = Array.new(4) { Freecell.new }
    @foundations = Card.suits.map { |suit| Foundation.new(suit) }
    @display = Display.new(self)
    # @player = Player.new(self)
    @player = AIPlayer.new(self)
    @map = create_map
    populate_tableaus(deck)
  end

  def won?
    tableaus.all? { |tab| tab.empty? } && freecells.all? { |fc| fc.empty? }
  end


  def play
    render
    puts "Ready???\n"
    sleep(1)
    puts "Set???????\n"
    sleep(1)
    puts "GO!!!!!!!!"
    sleep(1)
    gs = GameState.new(nil,
      tableaus: tableaus,
      freecells: freecells,
      foundations: foundations,
      prev_game_states: Hash.new(false))
    gs.generate_children
    # until attr_writer :attr_nameson?
    #   render
    #   player.take_turn
    # end
    #
    # puts "\n\n\nCRAZY CARD ANIMATION!!!\n\n\n"
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
  g = Game.new
  g.play
end
