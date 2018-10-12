require_relative "requirements"

class GameState < Game
  # this is a node that holds a game state, possible moves, and the results of
  ## those possible moves as children nodes

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
    # for each potential move, make the move and generate a new game state
    # with that game state make a child GameState node

    possible_moves = get_possible_moves

    render

    possible_moves.each do |from_pile, to_pile|
      new_from_key = reverse_map[from_pile].chr
      new_to_key = reverse_map[to_pile].chr
      puts "Possible move from #{new_from_key} to #{new_to_key}"
    end

    # byebug


    possible_moves.each do |from_pile, to_pile|
      to_pile.add!(from_pile.pop)
      if won?
        render
        puts "IT WORKED!!!!!!!!"
        exit
      end
      add_new_game_state(from_pile, to_pile) unless prev_game_states[compress]
      from_pile.add!(to_pile.pop)
    end

    # children.last.generate_children

    puts "\n\nResetting loop, we didn't seem to get anywhere...\n\n"
    sleep(0.5)

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

  attr_reader :freecells, :foundations, :tableaus, :losing, :children
  attr_reader :prev_game_states, :reverse_map, :from_key, :to_key
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
    # p results
    # byebug
  end

  def get_possible_moves
    # returns an array of arrays. each index represents a to_pile, from_pile row
    results = []

    foundations.each do |foundation|
      results += possible_moves_to_foundation(foundation)
    end
    
    tableaus.each do |tableau|
      results += possible_moves_from_tableau(tableau) unless tableau.empty?
    end

    freecells.each do |freecell|
      results += possible_moves_from_freecell(freecell) unless freecell.empty?
    end

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
    results = []
    top = tableau.peek

    tableaus.each { |tableau2| results << [tableau, tableau2] if tableau2.valid_add?(top)}
    results << [tableau, empty_freecell] if empty_freecell?

    results
  end

  def possible_moves_from_freecell(freecell)
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
