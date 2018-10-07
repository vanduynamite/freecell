require 'card'
require 'tableau'

describe Tableau do

  subject(:tableau) { Tableau.new }
  let(:card_red_1) { Card.new(:diamonds, :ace) }
  let(:card_black_1) { Card.new(:spades, :ace) }
  let(:card_red_2) { Card.new(:hearts, :deuce) }
  let(:card_black_2) { Card.new(:clubs, :deuce) }
  let(:card_red_3) { Card.new(:diamonds, :three) }
  let(:card_black_3) { Card.new(:spades, :three) }

  it "does not allow access to the stack" do
    expect(tableau).not_to respond_to(:stack)
  end

  describe "#force_push" do
    before(:each) { tableau.force_push(card_black_1) }

    it "does not raise error if card is incorrect color" do
      expect { tableau.force_push(card_black_2).to_not raise_error }
    end

    it "does not raise error if card is incorrect value" do
      expect { tableau.force_push(card_red_2).to_not raise_error }
    end
  end

  describe "#empty" do
    it "returns true when the tableau is empty" do
      expect(tableau.empty?).to be true
    end
    it "returns false when the tableau is not empty" do
      tableau.force_push(card_black_1)
      expect(tableau.empty?).to be false
    end
  end

  describe "#initialize" do
    it "starts with an empty stack of cards" do
      expect(tableau.empty?).to be true
    end
  end

  describe "#peek" do
    it "shows the last card on the tableau" do
      tableau.force_push(card_black_1)
      expect(tableau.peek).to eq(card_black_1)
    end
    it "returns nil if the tableau is empty" do
      expect(tableau.peek).to be nil
    end
  end

  describe "#length" do
    it "returns the size of the tableau" do

    end
    it "returns 0 if the tableau is empty" do

    end
  end

  describe "#pop" do

    before(:each) { tableau.force_push(card_red_2) }

    it "returns the last card on the tableau" do
      expect(tableau.pop).to eq(card_red_2)
    end

    it "removes the last card from the tableau" do
      tableau.force_push(card_black_1)
      tableau.pop
      expect(tableau.length).to eq(1)
    end
    it "raises an error if the tableau is empty" do
      tableau.pop
      expect { tableau.pop }.to raise_error "tableau is empty"
    end
  end

  describe "#add" do
    before(:each) { tableau.force_push(card_red_3) }

    it "does not raise an error adding cards with the correct color and value" do
      expect { tableau.add(card_black_2) }.to_not raise_error
      expect { tableau.add(card_red_1) }.to_not raise_error
    end

    it "raises error if the card is not the correct color" do
      expect { tableau.add(card_red_2) }.to raise_error "color is wrong"
    end

    it "raises error if the card is not the correct value" do
      expect { tableau.add(card_black_1) }.to raise_error "value is wrong"
      expect { tableau.add(card_black_3) }.to raise_error "value is wrong"
    end
    it "does not raise an error if the tableau is empty" do
      tableau.pop
      expect { tableau.add(card_black_1) }.to_not raise_error
      tableau.pop
      expect { tableau.add(card_black_3) }.to_not raise_error
      tableau.pop
      expect { tableau.add(card_red_2) }.to_not raise_error
    end
  end

  describe "#[]" do
    it "returns card at index" do
      tableau.add(card_black_3)
      tableau.add(card_red_2)
      tableau.add(card_black_1)
      expect(tableau[0]).to eq(card_black_3)
      expect(tableau[1]).to eq(card_red_2)
      expect(tableau[2]).to eq(card_black_1)
    end
  end

end
