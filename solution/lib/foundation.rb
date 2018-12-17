require_relative "tableau"

class Foundation < Tableau

  attr_reader :suit

  def initialize(suit, stack = [])
    @suit = suit
    super(stack)
  end

  def valid_add?(card)
    raise "wrong suit" unless card.suit == suit
    return true if empty? && card.value == :ace
    raise "first card must be ace" if empty? && card.value != :ace
    raise "wrong number" unless card.freecell_value == peek.freecell_value + 1
    true
  end

  def deep_dup
    Foundation.new(suit, stack.dup)
  end

  def to_s
    # only for display purposes
    return "  " if empty?
    peek.to_s
  end

end
