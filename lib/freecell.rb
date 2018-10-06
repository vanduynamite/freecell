require_relative "tableau"

class Freecell < Tableau

  def add(card)
    raise "freecell is not empty" unless empty?
    stack << card
  end

  def to_s
    return "  " if empty?
    peek.to_s
  end

end
