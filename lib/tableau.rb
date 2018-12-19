require "byebug"
require_relative 'deck'

class Tableau

  attr_accessor :stack

  def initialize(stack = [])
    @stack = stack
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

  def index_in_order?(i)
    return true if i == 0
    return false if stack[i].color == stack[i - 1].color
    return false if stack[i].freecell_value + 1 != stack[i - 1].freecell_value
    return true
  end

  def [](i)
    stack[i]
  end

  def length
    stack.length
  end

  def deep_dup
    Tableau.new(stack.dup)
  end

  def score

    sum = 0
    max = 13
    buried_value = 0

    (0...@stack.length).each do |i|
      val = @stack[i].freecell_value

      sum += 10 * (max + 1 - val) # every card on the board is worth some points
      sum += 10 unless index_in_order?(i) # if not sorted with card above
      sum += 10 * (10 - val) if i == 0 # bottom card in stack being not-a-ten

      if buried_value > 0 # add points to this card if it's on top of an ace
        sum += 10 * buried_value
        buried_value -= 1
      end

      # if this is an ace, other cards below are worse
      buried_value += max + 1 - val unless index_in_order?(i)

    end

    sum
  end

end
