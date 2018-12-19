require_relative 'card'

class Deck

  def self.all_cards
    cards = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards
  end

  def initialize(cards = Deck.all_cards)
    # @cards = cards.shuffle(random: Random.new(31415926))
    @cards = cards.shuffle
    # @cards = cards.reverse
  end

  def count
    @cards.count
  end

  def pop
    raise "not enough cards" if count == 0
    @cards.pop
  end

end
