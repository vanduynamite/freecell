require_relative "requirements"

class AIPlayer < Player

  attr_reader :start_node, :nodes_to_visit

  def initialize(game)
    super(game, "Hal")

    @start_node = GameNode.new(nil,
      tableaus: game.tableaus,
      freecells: game.freecells,
      foundations: game.foundations,
      graph: Hash.new(false))

    @nodes_to_visit = [start_node]
    @nodes_visited = Set.new
  end

  def take_turn
    if nodes_to_visit.empty?
      game.impossible(start_node)
    end

    node = get_next_node
    nodes_visited.add(node.compressed)
    node.generate_children
    nodes_to_visit.concat(node.children)

    game.tableaus = node.tableaus
    game.freecells = node.freecells
    game.foundations = node.foundations
  end

  def get_next_node
    node = nil

    while node == nil || nodes_visited.include?(node.compressed)
      # node = nodes_to_visit.pop # depth first, which is far better
      node = nodes_to_visit.shift # breadth first, which could get the best solution
    end

    return node
  end

  def end_game(print_nodes = false)
    puts "Took #{Time.now() - start_time} seconds"
    puts "Found #{start_node.graph.count} nodes"
    puts "Visited #{nodes_visited.count} nodes"

    return unless print_nodes

    start_node.graph.each do |key, node|
      # puts key
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
