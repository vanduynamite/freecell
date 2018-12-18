require_relative "requirements"

class AIPlayer < Player

  attr_reader :start_node, :nodes_to_visit

  def initialize(game)
    super(game, "Hal")

    @start_node = GameNode.new(nil,
      tableaus: game.tableaus,
      freecells: game.freecells,
      foundations: game.foundations,
      all_nodes: Hash.new(0))

    @nodes_to_visit = [start_node]
  end

  def take_turn
    if nodes_to_visit.empty?
      game.impossible(start_node)
    end
    # node = nodes_to_visit.pop # depth first
    node = nodes_to_visit.shift # breadth first
    self.nodes_visited = nodes_visited + 1
    game.tableaus = node.tableaus
    game.freecells = node.freecells
    game.foundations = node.foundations
    node.generate_children
    nodes_to_visit.concat(node.children)
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
