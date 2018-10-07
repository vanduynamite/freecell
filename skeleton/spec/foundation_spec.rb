require 'foundation'
require 'card'

describe Foundation do

  subject(:foundation) { Foundation.new(:hearts) }
  let(:card_red_1) { Card.new(:hearts, :ace) }
  let(:card_black_1) { Card.new(:spades, :ace) }
  let(:card_red_2) { Card.new(:hearts, :deuce) }
  let(:card_black_2) { Card.new(:spades, :deuce) }
  let(:card_red_3) { Card.new(:hearts, :three) }

  describe '#initialize' do
    it 'correctly sets the suit' do
      expect(foundation.suit).to eq(:hearts)
    end
  end

  describe '#add' do

    it "raises error if the suit is incorrect" do
      expect { foundation.add(card_black_1) }.to raise_error "wrong suit"
      foundation.add(card_red_1)
      expect { foundation.add(card_black_2) }.to raise_error "wrong suit"
    end

    it "raises error if the first card is not an ace" do
      expect { foundation.add(card_red_2) }.to raise_error "first card must be ace"
    end

    it "allows an ace to be added as the first card" do
      expect { foundation.add(card_red_1) }.to_not raise_error
      expect(foundation.peek).to eq(card_red_1)
    end

    it "raises error if the next card is not sequential" do
      foundation.add(card_red_1)
      expect { foundation.add(card_red_3) }.to raise_error "wrong number"
    end

    it "allows sequential cards of the same suit to be added" do
      foundation.add(card_red_1)
      expect { foundation.add(card_red_2) }.to_not raise_error
      expect { foundation.add(card_red_3) }.to_not raise_error
    end

  end

end
