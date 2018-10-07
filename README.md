# Freecell by vanduynamite

## A note from the author
Please realize that this is just my interpretation of the freecell game and its solution. DO NOT assume in any way that this solution will be similar or even close to the assessment. This was helpful for me to internalize the rules of the game and to try my hand at writing some specs. I am still learning rspec and therefore I think my specs are pretty simple. Very few doubles or other complicated situations.

I harvested almost all of Cards and much of Deck from the Blackjack practice assessment. The Card file was changed to account for the different values (blackjack considers face cards to be 10), and to look for the color of a card.

One personal note on the rules - if you've played fancy phone versions of the game you notice you can move multiple cards from a tableau if you have the correct spots available. This is NOT implemented in my version, and IN MY OPINION (my opinion!) I don't think this will be on the assessment. If you look at Just my opinion.

All that being said, I hope you find this helpful! Good luck!


## Rules

You should really run the specs in this order:

```
bundle exec rspec spec/deck_spec.rb
bundle exec rspec spec/tableau_spec.rb
bundle exec rspec spec/freecell_spec.rb
bundle exec rspec spec/foundation_spec.rb
bundle exec rspec spec/player_spec.rb
bundle exec rspec spec/game_spec.rb
```

* To run one specific spec, add `:line_number` at the end.  For example, `bundle exec rspec spec/deck_spec.rb:30`

* Wait until you finish to run `rspec spec`, which will run all the
  tests. Do this as a final check that you have them all passing.

## Game Rules

Copied from the email send EOD W2D5

* The goal is to move all the cards from the Tableau piles to the Foundation piles by moving one card at a time.
* The cards are dealt evenly among the Tableau piles at the beginning of the game.
* A card can be moved to a FreeCell pile if the receiving pile is empty.
* A card can be moved to a Tableau pile if the top card is of the opposite color and has a value of one higher (i.e., if the top card of the pile is the Jack of clubs, we could move the ten of hearts onto the pile).
* The first card moved to a Foundation pile must be an ace of the correct suit.
* Additional cards can be moved to a Foundation pile if the card is of the correct suit and has a value one higher than the top card (i.e., if the top card of the pile is the two of hearts, we could move the three of hearts onto the pile).
* The game is won when all of the cards have been moved to the Foundation piles.
* Further game rules are described on Wikipedia
