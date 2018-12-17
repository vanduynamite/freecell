require_relative "requirements"

class AIPlayer < Player

  def initialize(game)
    super(game, "Hal")
  end

  def take_turn

    # gs = GameState.new(nil,
    #   tableaus: tableaus,
    #   freecells: freecells,
    #   foundations: foundations,
    #   prev_game_states: Hash.new(false))
    # gs.generate_children



    begin
      from_pile = game.map[get_from_pile.ord]
      to_pile = game.map[get_to_pile.ord]
      to_pile.valid_add?(from_pile.peek)
      to_pile.add!(from_pile.pop)
    rescue => e
      puts e.message
      retry
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
