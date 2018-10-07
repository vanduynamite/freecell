require 'card'
require 'game'

describe Game do

  deck_cards = [
    Card.new(:spades, :deuce),
    Card.new(:hearts, :deuce),
    Card.new(:diamonds, :deuce),
    Card.new(:clubs, :deuce),
    Card.new(:spades, :ace),
    Card.new(:hearts, :ace),
    Card.new(:diamonds, :ace),
    Card.new(:clubs, :ace),
  ]

  subject(:game) { Game.new(deck_cards) }

  describe "#initialize" do

    it "starts the game with 8 tableaus" do
      expect(game.tableaus.count).to be(8)
    end

    it "starts the game with 4 empty freecells" do
      expect(game.freecells.count).to be(4)
    end

    it "starts the game with 4 empty foundations" do
      expect(game.foundations.count).to be(4)
    end

    it "populates the tableaus with cards from the deck until the deck is empty" do
      8.times do |i|
        expect(game.tableaus[i].peek).to eq(deck_cards[i])
      end
    end

  end

  describe "#won?" do

    game = Game.new(deck_cards)

    it "returns false if there are still cards in the tableaus" do
      expect(game.won?).to be false
    end

    it "returns false if there are still cards in the freecells" do
      4.times { |i| game.foundations[i].add(game.tableaus[i].pop) }
      4.times { |i| game.freecells[i].add(game.tableaus[i + 4].pop) }
      expect(game.won?).to be false
    end

    it "returns true if no cards in freecells or tableau" do
      4.times { |i| game.foundations[i].add(game.freecells[i].pop) }
      expect(game.won?).to be true
    end

  end

end
