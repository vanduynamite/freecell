require_relative "requirements"

class GameNode < Game

  attr_accessor :distance_from_root
  attr_reader :graph, :children, :compressed, :score

  def initialize(parent, options)
    @parent = parent
    @distance_from_root = parent ? parent.distance_from_root + 1 : 0
    @children = []

    @tableaus = options[:tableaus]
    @freecells = options[:freecells]
    @foundations = options[:foundations]

    @compressed = compress_node
    @score = score_node

    @graph = options[:graph]
    update_graph
  end

  def generate_children
    possible_moves = get_possible_moves
    possible_moves.each do |from_pile, to_pile|
      to_pile.add!(from_pile.pop)
      add_new_node
      from_pile.add!(to_pile.pop) # don't change the state of this node
    end
  end

  def add_new_node
    children << GameNode.new(self,
      tableaus: tableaus_dup,
      freecells: freecells_dup,
      foundations: foundations_dup,
      graph: graph)
  end

  def update_graph
    if graph.include?(compressed)
      # some more special stuff here??? Update parents to have this child?
      if graph[compressed].distance_from_root > distance_from_root
        graph[compressed] = self
      end
    else
      graph[compressed] = self
    end
  end

  def compress_node
    results = {
      tableaus: Set.new,
      freecells: Set.new,
      foundations: Set.new,
    }

    tableaus.each { |t| results[:tableaus].add(t.stack.hash) }
    freecells.each { |f| results[:freecells].add(f.stack.hash) }
    foundations.each { |f| results[:foundations].add(f.stack.hash) }

    results
  end

  def tableaus_dup
    tableaus.map { |t| t.deep_dup }
  end

  def freecells_dup
    freecells.map { |t| t.deep_dup }
  end

  def foundations_dup
    results = foundations.map { |t| t.deep_dup }
  end

  def get_possible_moves
    results = []
    freecells.each { |freecell| results += possible_moves_from_freecell(freecell) }
    tableaus.each { |tableau| results += possible_moves_from_tableau(tableau) }
    foundations.each { |foundation| results += possible_moves_to_foundation(foundation) }
    results
  end

  def possible_move?(pile, card)
    begin
      pile.valid_add?(card)
      return true
    rescue => e
      # puts e.message # if you want to see all the possible moves that don't work
      return false
    end
  end

  def possible_moves_to_foundation(foundation)
    results = []
    piles = freecells + tableaus
    piles.each do |pile|
      unless pile.empty?
        results << [pile, foundation] if possible_move?(foundation, pile.peek)
      end
    end

    results
  end

  def possible_moves_from_tableau(tableau)
    return [] if tableau.empty?
    results = []
    top = tableau.peek

    tableaus.each do |tableau2|
      if (!tableau2.empty? || tableau.length > 1)
        results << [tableau, tableau2] if possible_move?(tableau2, top)
      end
    end

    results << [tableau, empty_freecell] if empty_freecell?

    results
  end

  def possible_moves_from_freecell(freecell)
    return [] if freecell.empty?

    results = []
    top = freecell.peek
    tableaus.each do |tableau|
      results << [freecell, tableau] if possible_move?(tableau, top)
    end

    results
  end

  def empty_freecell?
    freecells.any? { |freecell| freecell.empty? }
  end

  def empty_freecell
    freecells.select { |freecell| freecell.empty? }.first
  end

  def score_node
    score = 0
    # foundations.each { |f| score += 0 } # anything on a foundation costs 0
    freecells.each { |f| score += f.score }
    tableaus.each { |t| score += t.score }
    score
  end

end
