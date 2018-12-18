require_relative "tableau"

class Freecell < Tableau

  def valid_add?(card)
    raise "freecell is not empty" unless empty?
    true
  end

  def deep_dup
    Freecell.new(stack.dup)
  end

  def compress
    return nil if stack == []
    stack
  end

  def to_s
    # only for display purposes
    return "  " if empty?
    peek.to_s
  end

  def score
    return 0 if empty?
    max = 10
    10 * (max + 1 - stack[0].freecell_value)
  end

end
