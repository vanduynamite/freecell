require_relative 'deck'

class Tableau

  def initialize
    @stack = []
  end

  def pop
    raise "tableau is empty" if empty?
    stack.pop
  end

  def peek
    stack.last
  end

  def empty?
    stack.empty?
  end

  def add(card)
    unless empty?
      raise "value is wrong" unless card.freecell_value + 1 == peek.freecell_value
      raise "color is wrong" if card.color == peek.color
    end

    stack << card
  end

  def force_push(card)
    stack << card
  end

  def [](i)
    # only used for display purposes
    stack[i]
  end

  def length
    # only used for display purposes
    stack.length
  end

  private
  attr_accessor :stack

end
