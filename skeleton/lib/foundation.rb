require_relative "tableau"

class Foundation < Tableau

  attr_reader :suit

  def initialize(suit)

    super()
  end

  def add(card)

  end

  def to_s
    # only for display purposes
    return "  " if empty?
    peek.to_s
  end

end
