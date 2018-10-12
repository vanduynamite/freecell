require "byebug"

class Display

  def initialize(game)
    @game = game
  end

  def render
    sleep(0.03)
    system("clear")
    render_top
    render_tableaus
  end

  private
  attr_reader :game

  def render_tableaus
    puts TAB_CARD_NUMS, TAB_CARD_LINE
    (0...game.tableau_lengths.max).each { |i| render_tableau_line(i) }
  end

  def render_tableau_line(i)
    line = ""
    next_line = " "
    game.tableaus.each_with_index do |tableau|
      if i < tableau.length
        line += "|  " + tableau[i].to_s + "  |  "
        next_line += "------    "
      else
        line += "          " unless i < tableau.length
        next_line += "          "
      end
    end
    puts line, next_line
  end

  def render_top
    puts TOP_CARD_LETTERS, TOP_CARD_LINE, TOP_CARD_SIDES
    line = "|  "
    (0...4).each do |i|
      if i < game.freecells.length
        freecell = game.freecells[i]
        line += freecell.to_s + "  | "
      else
        line += "    | "
      end

      line += "|  " if i < 3
    end
    line += "       |  "
    game.foundations.each_with_index do |foundation, i|
      line += foundation.to_s + "  | "
      line += "|  " if i < game.foundations.length - 1
    end
    puts line, TOP_CARD_SIDES, TOP_CARD_LINE, "\n\n"
  end

  EMPTY_LINE = "\n"
  TOP_CARD_LETTERS = "   a        b        c        d               w♣       x♦       y♥       z♠  "
  TOP_CARD_LINE =    " ------   ------   ------   ------          ------   ------   ------   ------"
  TOP_CARD_SIDES = "|      | |      | |      | |      |        |      | |      | |      | |      |"
  TAB_CARD_NUMS =  "   0         1         2         3         4         5         6         7   "
  TAB_CARD_LINE  = " ------    ------    ------    ------    ------    ------    ------    ------"
end
