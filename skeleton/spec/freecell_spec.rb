require 'freecell'
require 'card'

describe Freecell do

  subject(:freecell) { Freecell.new }
  let(:card_red_1) { Card.new(:hearts, :ace) }
  let(:card_black_1) { Card.new(:spades, :ace) }
  let(:card_red_2) { Card.new(:hearts, :deuce) }
  let(:card_red_3) { Card.new(:hearts, :three) }

  describe '#add' do

    it "allows any card to be added if empty" do
      expect { freecell.add(card_red_1) }.to_not raise_error
      freecell.pop
      expect { freecell.add(card_red_2) }.to_not raise_error
      freecell.pop
      expect { freecell.add(card_red_3) }.to_not raise_error
    end

    it "does not allow a card to be added if not empty" do
      freecell.add(card_red_1)
      expect { freecell.add(card_red_1) }.to raise_error "freecell is not empty"
    end

  end

end
