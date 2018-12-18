require_relative "requirements"

class GameNode < Game

  attr_accessor :distance_from_root
  attr_reader :all_nodes, :children

  def initialize(parent, options)
    @parent = parent
    @distance_from_root = parent ? parent.distance_from_root + 1 : 0
    @children = []

    @tableaus = options[:tableaus]
    @freecells = options[:freecells]
    @foundations = options[:foundations]

    @all_nodes = options[:all_nodes]
  end

  def generate_children

    get_possible_moves.each do |from_pile, to_pile|
      to_pile.add!(from_pile.pop)
      compressed = compress_node
      if all_nodes[compressed] == 0
        add_new_game_state(from_pile, to_pile)
      elsif all_nodes[compressed] > distance_from_root
        # byebug
        # all_nodes[compressed].distance_from_root = distance_from_root
        # ideally something in here about shortening the path to victory
      end
      from_pile.add!(to_pile.pop)
    end

  end

  def add_new_game_state(from_pile, to_pile)
    self.all_nodes[compress_node] = 1

    children << GameNode.new(self,
      tableaus: tableaus_dup,
      freecells: freecells_dup,
      foundations: foundations_dup,
      all_nodes: all_nodes)

  end

  def compress_node
    results = {
      tableaus: Hash.new,
      freecells: Hash.new,
      foundations: Hash.new,
    }
    tableaus.each { |t| results[:tableaus][t.stack] = true }
    freecells.each { |f| results[:freecells][f.stack] = true }
    foundations.each { |f| results[:foundations][f.stack] = true }
    # return results

    results = []
    tableaus.each { |t| results += t.stack + [nil] }
    freecells.each { |f| results += f.stack + [nil] }
    foundations.each { |f| results += f.stack + [nil] }
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
      # puts e.message
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

    results << [tableau, empty_freecell] if empty_freecell? && tableau.length > 1

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

  # def build_reverse_map
  #   {
  #     tableaus[0] => 48,
  #     tableaus[1] => 49,
  #     tableaus[2] => 50,
  #     tableaus[3] => 51,
  #     tableaus[4] => 52,
  #     tableaus[5] => 53,
  #     tableaus[6] => 54,
  #     tableaus[7] => 55,
  #     freecells[0] => 97,
  #     freecells[1] => 98,
  #     freecells[2] => 99,
  #     freecells[3] => 100,
  #     foundations[0] => 119,
  #     foundations[1] => 120,
  #     foundations[2] => 121,
  #     foundations[3] => 122,
  #   }
  # end

end
