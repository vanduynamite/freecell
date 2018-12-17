require_relative "requirements"

class GameNode < Game
  attr_reader :freecells, :foundations, :tableaus, :children, :display
  attr_reader :prev_game_states, :reverse_map

  def initialize(parent, options)
    @parent = parent
    @children = []

    @tableaus = options[:tableaus]
    @freecells = options[:freecells]
    @foundations = options[:foundations]

    @display = Display.new(self)
    @reverse_map = build_reverse_map
    @prev_game_states = options[:prev_game_states]
  end

  def generate_children
    render

    get_possible_moves.each do |from_pile, to_pile|
      to_pile.add!(from_pile.pop)
      end_game if won?
      add_new_game_state(from_pile, to_pile) unless prev_game_states[compress]
      from_pile.add!(to_pile.pop)
    end

    # children.last.generate_children # breadth first solve

  end

  def add_new_game_state(from_pile, to_pile)
    new_from_key = reverse_map[from_pile].chr
    new_to_key = reverse_map[to_pile].chr
    puts "Possible move from #{new_from_key} to #{new_to_key}"
    self.prev_game_states[compress] = true

    children << GameNode.new(self,
      tableaus: tableaus_dup,
      freecells: freecells_dup,
      foundations: foundations_dup,
      prev_game_states: prev_game_states)

    children.last.generate_children # depth first solve
  end

  def compress
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

    foundations.each { |foundation| results += possible_moves_to_foundation(foundation) }
    tableaus.each { |tableau| results += possible_moves_from_tableau(tableau) }
    freecells.each { |freecell| results += possible_moves_from_freecell(freecell) }

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

  def build_reverse_map
    {
      tableaus[0] => 48,
      tableaus[1] => 49,
      tableaus[2] => 50,
      tableaus[3] => 51,
      tableaus[4] => 52,
      tableaus[5] => 53,
      tableaus[6] => 54,
      tableaus[7] => 55,
      freecells[0] => 97,
      freecells[1] => 98,
      freecells[2] => 99,
      freecells[3] => 100,
      foundations[0] => 119,
      foundations[1] => 120,
      foundations[2] => 121,
      foundations[3] => 122,
    }
  end

end
