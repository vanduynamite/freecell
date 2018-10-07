require 'byebug'
require 'card'
require 'deck'

describe Deck do
  describe "::all_cards" do
    subject(:all_cards) { Deck.all_cards }

    it "starts with a count of 52" do
      expect(all_cards.count).to eq(52)
    end

    it "returns all cards without duplicates" do
      all_card_vals = Card.suits.product(Card.values).sort

      deduped_cards = all_cards
        .map { |card| [card.suit, card.value] }
        .sort

      expect(deduped_cards).to eq(all_card_vals)
    end

  end

  let(:cards) do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack)
    ]
  end

  let(:unshuffled_cards) do
    unshuffled_cards = Deck.all_cards
  end

  describe "#initialize" do
    it "by default fills itself with 52 cards" do
      deck = Deck.new
      expect(deck.count).to eq(52)
    end

    it "can be initialized with an array of cards" do
      deck = Deck.new(cards)
      expect(deck.count).to eq(3)
    end

    it "shuffles cards" do
      deck = Deck.new
      shuffled_cards = []
      deck.count.times { |_| shuffled_cards << deck.pop }
      expect(shuffled_cards).to_not eq(unshuffled_cards)
    end
  end

  it "does not expose its cards directly" do
    deck = Deck.new
    expect(deck).not_to respond_to(:cards)
  end

  describe "#pop" do
    # **use the BACK!!! of the cards array as the top**

    it "takes cards off the top of the deck" do
      card = Card.new(:spades, :ace)
      deck = Deck.new([card])
      expect(deck.pop).to eq(card)
    end

    it "removes cards from deck on take" do
      deck = Deck.new
      deck.pop
      expect(deck.count).to eq(51)
    end

    it "doesn't allow you to take more cards than are in the deck" do
      deck = Deck.new
      expect do
        53.times { deck.pop }
      end.to raise_error("not enough cards")
    end
  end

end
