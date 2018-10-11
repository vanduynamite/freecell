require "byebug"
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
    add!(card) if valid_add?(card)
  end

  def add!(card)
    stack << card
  end

  def valid_add?(card)
    return true if empty?
    raise "color is wrong" if card.color == peek.color
    raise "value is wrong" unless card.freecell_value + 1 == peek.freecell_value
    return true
  end

  def [](i)
    stack[i]
  end

  def length
    stack.length
  end

  private
  attr_accessor :stack

end
