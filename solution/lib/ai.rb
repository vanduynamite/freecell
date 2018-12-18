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

    node = get_next_node
    nodes_visited.add(node.compressed)
    node.generate_children
    self.nodes_to_visit = update_traverse_tree(node)
    self.last_node_visited = node

    game.tableaus = node.tableaus
    game.freecells = node.freecells
    game.foundations = node.foundations
  end

  def update_traverse_tree(node)
    nodes_to_add = custom_sort(node.children)
    return nodes_to_visit + nodes_to_add
  end

  def get_next_node
    nodes_to_visit.pop
  end

  def custom_sort(nodes)
    result = remove_visited_nodes(nodes)
    result = result.sort_by { |h| h.score }.reverse
    result
  end

  def remove_visited_nodes(nodes)
    nodes.reject { |node| nodes_visited.include?(node.compressed) }
  end

  def end_game(print_nodes = false)
    puts "Took #{Time.now() - start_time} seconds"
    puts "Found #{start_node.graph.count} nodes"
    puts "Visited #{nodes_visited.count} nodes"
    puts "Last node visited distance: #{last_node_visited.distance_from_root}"
    puts "Average nodes per second: #{nodes_visited.count / (Time.now() - start_time)}"

    return unless print_nodes

    start_node.graph.each do |key, node|
      puts key
      print "\nFreecells: "
      node.freecells.each { |t| print "#{t} " }
      print "\nFoundations: "
      node.foundations.each { |t| print "#{t} " }
      puts "\nTableaus:"
      node.tableaus.each do |t|
        t.stack.each { |card| print "#{card} "}
        puts
      end
    end


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
