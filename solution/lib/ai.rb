require_relative "requirements"

class AIPlayer < Player

  attr_reader :start_node

  def initialize(game)
    super(game, "Hal")

    @start_node = GameNode.new(nil,
      tableaus: game.tableaus,
      freecells: game.freecells,
      foundations: game.foundations,
      prev_game_states: Hash.new(false))

    @nodes = [start_node]
  end

  def take_turn
    generate_node_graph
  end

  def generate_node_graph
    start_node.generate_children
  end

  private

  ACCEPTABLE_FROM = ("0".."7").to_a + ("a".."d").to_a
  ACCEPTABLE_TO = ACCEPTABLE_FROM + ("w".."z").to_a

  def get_from_pile
    sleep(1)
  end

  def get_to_pile
    sleep(1)
  end

end
