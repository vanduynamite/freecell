require_relative "tableau"

class Freecell < Tableau

  def valid_add?(card)
    raise "freecell is not empty" unless empty?
    true
  end

  def to_s
    # only for display purposes
    return "  " if empty?
    peek.to_s
  end

end
