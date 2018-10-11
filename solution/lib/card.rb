require "colorize"

# -*- coding: utf-8 -*-

# Represents a playing card.
class Card
  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  SUIT_COLORS = {
    :clubs    => :black,
    :diamonds => :red,
    :hearts   => :red,
    :spades   => :black,
  }

  VALUE_STRINGS = {
    :ace   => "A",
    :deuce => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "T",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
  }

  FREECELL_VALUE = {
    ace: 1,
    deuce: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    ten: 10,
    jack: 11,
    queen: 12,
    king: 13,
  }

  # Returns an array of all suits.
  def self.suits
    SUIT_STRINGS.keys
  end

  # Returns an array of all values.
  def self.values
    VALUE_STRINGS.keys
  end

  attr_reader :suit, :value

  def initialize(suit, value)
    unless Card.suits.include?(suit) and Card.values.include?(value)
      raise "illegal suit (#{suit}) or value (#{value})"
    end

    @suit, @value = suit, value
  end

  def freecell_value
    FREECELL_VALUE[value]
  end

  def color
    SUIT_COLORS[suit]
  end

  def to_s
    VALUE_STRINGS[value] + SUIT_STRINGS[suit].colorize(color)
  end
  
end
