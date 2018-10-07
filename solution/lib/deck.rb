require_relative 'card'

# Represents a deck of playing cards.
class Deck
  # Returns an array of all 52 playing cards.
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
    @cards = cards.shuffle
  end

  # Returns the number of cards in the deck.
  def count
    @cards.count
  end

  def pop
    raise "not enough cards" if count == 0
    @cards.pop
  end

end
