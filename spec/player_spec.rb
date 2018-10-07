require 'player'
require 'game'

describe Player do

  describe "#initialize" do

    it "assigns the name" do
      game = double("game")
      player = Player.new(game, "Steve Jobs")
      expect(player.name).to eq("Steve Jobs")
    end

    it "assigns the game" do
      game = double("game")
      player = Player.new(game, "Steve Jobs")
      expect(player.game).to eq(game)
    end

  end

  describe "#take_turn" do
    let(:game) { double("game") }
    let(:player) { double("player") }
    # subject(:player) { Player.new(game, "Steve Jobs") }
    # expect(game).to receive(:map).with(deck)

    it "gets a from and to pile????" do
      # expect(hand).to receive(:return_cards).with(deck)
      # player.return_cards(deck)
    end

  end

end
