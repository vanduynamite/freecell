require_relative "tableau"

class Foundation < Tableau

  def initialize(suit)
    @suit = suit
    super()
  end

  def add(card)

    unless card.value == :ace
      raise "first card must be ace" if empty?
      raise "wrong number" unless card.freecell_value == peek.freecell_value + 1
    else
      raise "wrong suit" unless card.suit == suit
    end

    stack << card
  end

  def to_s
    return "  " if empty?
    peek.to_s
  end

  private
  attr_reader :suit

end
