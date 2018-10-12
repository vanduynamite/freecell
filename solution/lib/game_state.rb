require_relative "requirements"

class GameState < Game
  attr_reader :freecells, :foundations, :tableaus, :losing, :children
  attr_reader :prev_game_states, :reverse_map, :from_key, :to_key

  def initialize(parent, options)
    @parent = parent # parent node of GameState type
    @children = []
    @display = Display.new(self)

    @from_key = options[:from_key]
    @to_key = options[:to_key]

    @tableaus = options[:tableaus]
    @freecells = options[:freecells]
    @foundations = options[:foundations]
    @reverse_map = build_reverse_map

    @prev_game_states = options[:prev_game_states]
  end

  def generate_children
    render

    get_possible_moves.each do |from_pile, to_pile|
      to_pile.add!(from_pile.pop)
      winning_message if won?
      add_new_game_state(from_pile, to_pile) unless prev_game_states[compress]
      from_pile.add!(to_pile.pop)
    end

    # children.last.generate_children # for breadth first?

    # puts "\n\nResetting loop, we didn't seem to get anywhere going down that rabbit hole...\n\n"
    # sleep(0.3)
  end

  def add_new_game_state(from_pile, to_pile)
    new_from_key = reverse_map[from_pile].chr
    new_to_key = reverse_map[to_pile].chr
    puts "Possible move from #{new_from_key} to #{new_to_key}"
    self.prev_game_states[compress] = true
    children << GameState.new(self,
      tableaus: tableaus_dup,
      freecells: freecells_dup,
      foundations: foundations_dup,
      from_key: new_from_key,
      to_key: new_to_key,
      prev_game_states: prev_game_states)

    children.last.generate_children
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
    # returns an array of arrays. each index represents a to_pile, from_pile row
    results = []

    foundations.each { |foundation| results += possible_moves_to_foundation(foundation) }
    tableaus.each { |tableau| results += possible_moves_from_tableau(tableau) }
    freecells.each { |freecell| results += possible_moves_from_freecell(freecell) }

    results
  end

  def possible_moves_to_foundation(foundation)
    results = []

    freecells.each do |freecell|
      unless freecell.empty?
        results << [freecell, foundation] if foundation.valid_add?(freecell.peek)
      end
    end

    tableaus.each do |tableau|
      unless tableau.empty?
        results << [tableau, foundation] if foundation.valid_add?(tableau.peek)
      end
    end

    results
  end

  def possible_moves_from_tableau(tableau)
    return [] if tableau.empty?
    results = []
    top = tableau.peek

    tableaus.each do |tableau2|
      if tableau2.valid_add?(top) && (!tableau2.empty? || tableau.length > 1)
        results << [tableau, tableau2]
      end
    end

    results << [tableau, empty_freecell] if empty_freecell? && tableau.length > 1

    results
  end

  def possible_moves_from_freecell(freecell)
    return [] if freecell.empty?

    results = []
    top = freecell.peek

    tableaus.each { |tableau| results << [freecell, tableau] if tableau.valid_add?(top) }

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
