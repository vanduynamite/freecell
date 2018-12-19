require_relative "requirements"

class AIPlayer < Player

  attr_accessor :last_node_visited, :nodes_to_visit
  attr_reader :start_node

  def initialize(game)
    super(game, "Hal")

    @start_node = GameNode.new(nil,
      tableaus: game.tableaus,
      freecells: game.freecells,
      foundations: game.foundations,
      graph: Hash.new(false))

    @nodes_to_visit = [start_node]
    @nodes_visited = Set.new
    @last_node_visited = nil
  end

  def take_turn
    if nodes_to_visit.empty?
      game.impossible(start_node)
    end

    node = nodes_to_visit.pop
    nodes_visited.add(node.compressed)
    node.generate_children
    self.nodes_to_visit = update_traverse_tree(node)
    self.last_node_visited = node

    game.tableaus = node.tableaus
    game.freecells = node.freecells
    game.foundations = node.foundations
  end


  def end_game
    # puts "Took #{Time.now() - start_time} seconds"
    # puts "Found #{start_node.graph.count} nodes"
    # puts "Visited #{nodes_visited.count} nodes"
    # puts "Last node visited distance: #{last_node_visited.distance_from_root}"

    return [start_node.graph.count, nodes_visited.count, last_node_visited.distance_from_root]
  end

  private

  def update_traverse_tree(node)
    nodes_to_add = custom_sort(node.children)
    result = nodes_to_visit + nodes_to_add
    return result
  end

  def custom_sort(nodes)
    result = remove_visited_nodes(nodes)
    result = reverse_qsort(result)
    result
  end

  def remove_visited_nodes(nodes)
    nodes.reject { |node| nodes_visited.include?(node.compressed) }
  end

  def reverse_qsort(nodes)
    return nodes if nodes.length <= 1
    pivot = nodes[0]
    left = reverse_qsort(nodes.select { |node| node.score > pivot.score })
    right = reverse_qsort(nodes[1..-1].select { |node| node.score <= pivot.score })
    left + [pivot] + right
  end

end
