# Freecell with Tests and Node Graph Solver

This program was originally created during the App Academy curriculum as a study guide for myself and my fellow students for one of our tests. It is a [test driven, object oriented](#test-driven-oop) Freecell game playable in the browser, and originally included a TDD 'blank slate' version to be filled out by the test taker.

After the class I created a [node tree solver](#node-graph-solver) to find a solution to any game of Freecell with a very basic algorithm to find and choose nodes. I later improved the solver to be a [node graph](#why-a-node-graph) which would consider nodes and update them if it found duplicates, creating a true graph. I also created a light-weight [custom data structure](#node-compression) to store game states, ensuring no game was tried twice. Lastly, I tuned the algorithm to choose [which node to explore next](#scoring-a-node) using some relatively simple rules score each potential game.

## Test Driven OOP
The file structure is clear and easy to understand, with separate files for the cards, deck, game, player, and each type of pile. The piles within Freecell (called the Tableaus, Freecells, and Foundation piles) are extremely similar and therefore use inheritance to keep the appropriate methods DRY.

There are 40 specs that ensure the game is working correctly, all written from scratch using RSPEC. The specs use the traditional RSPEC structure and therefore also have a sensible file structure.

### Game Loop and Display
The solver is an AI player that is duck-typed so that the same `game.rb` file can be used for both human and AI players. The game enters a `while` loop, asking for the player to take a turn until the game is in a solved state. The `sleep` is to allow a human to see the initial game state before the solver starts.

As is, when the AI is solving, each move will be interrupted by the `render` which displays the board and pauses for 0.03 seconds so a human can see that something is happening. This of course takes the majority of the time in solving, so the line can be commented out for speed.

```ruby
# game.rb

def play
  render
  sleep(1)

  until won?
    render # comment this out for a faster solve and no display
    player.take_turn
  end

  end_game
end
```

## Node Graph Solver
### AI Player
The AI player is initialized with a starting node and contains two important variables, a `@nodes_to_visit` array and a `@nodes_visited` Set.
Each time the AI is asked to take a turn it will:
* Pop the last value in `@nodes_to_visit`
* Store the [compressed version](#node-compression) of the node in `@nodes_visited`
* Calls the [generate_children](#node-generation) method on that node
* Update the [traverse tree](#update-traverse-tree) with the new children

```ruby
# ai.rb

def take_turn
  ...
  node = nodes_to_visit.pop
  nodes_visited.add(node.compressed)
  node.generate_children
  self.nodes_to_visit = update_traverse_tree(node)
  ...
end
```

### Node Compression
Early on I identified that the game would happily repeat the same move back and forth forever without getting anywhere. To prevent this, I created an interesting way to compress each node and store it in the `@nodes_visited`. The `GameNode#compress_node` method creates a Hashmap of Sets, where each Set contains the `Object#hash`ed value for each stack of cards.

```ruby
# game_node.rb
def compress_node
  results = {
    tableaus: Set.new,
    freecells: Set.new,
    foundations: Set.new,
  }

  tableaus.each { |t| results[:tableaus].add(t.stack.hash) }
  freecells.each { |f| results[:freecells].add(f.stack.hash) }
  foundations.each { |f| results[:foundations].add(f.stack.hash) }

  results
end
```

The reason I used Ruby's built in hash method to store a stack of cards instead of storing it as an array is because each array has a separate object_id even if they contain the exact same objects. But when hashing them they will be identical, and will take up a bit less space in memory!

```bash
[1] pry(main)> a = [1]
=> [1]
[2] pry(main)> b = [1]
=> [1]
[3] pry(main)> a.object_id == b.object_id
=> false
[4] pry(main)> a.hash == b.hash
=> true
```

For the next step up in the compressed_node data structure, I used a Set to store each group of stacks (tableau, freecell, foundation) so that the order of the stacks would not matter. For instance, moving the Ace of Spades from one freecell to another does not produce a different game state.

The highest level of the compressed_node data structure is simply a Hashmap that contains keys of the type of pile and their values of the Sets mentioned above. I chose to not hash this entire Hashmap structure and leave it mnemonic so that I could actually see which piles were changing during debugging.

```ruby
# example of the compressed_node data structure
# values do not represent the actual hash values
compressed_node = {
  tableaus: {
    -2491393088345883972,
    2379442503241871702,
    377715789934734689,
    -1813092697732765317,
    -3832834904766044907,
    3379880192856989996,
    -968222884092027590,
    -2987893622869501488,
  },
  freecells: {
    4224743538306340335, # this may represent an empty stack and is repeated below
    -2129513015681856109,
    -4149255085280376402,
    # there is no fourth line because two freecell stacks are empty and this is a set
  },
  foundations: {
    3027424615032702016,
    4224743538306340335, # also an empty stack
    # there is no third and fourth line because three foundations are empty
  },
}

```

### Node Generation
When a Node generates children, it simply runs through any possible move of one card from one stack to a different stack and checks to see if that move is valid according to the rules of the game.

```ruby
def get_possible_moves
  results = []
  freecells.each { |freecell| results += possible_moves_from_freecell(freecell) }
  tableaus.each { |tableau| results += possible_moves_from_tableau(tableau) }
  foundations.each { |foundation| results += possible_moves_to_foundation(foundation) }
  results
end
```

Each possible move is stored as an array of `[from_pile, to_pile]` and Because each type of stack has a `#pop` and an `#add` method, the whole list of possible moves can be DRYly checked against the rules in one loop.

### Update Traverse Tree
When a child node is initialized, its game state is scored. And when each node is done generating children, those children are sorted by their score added to the AI's `@nodes_to_visit` variable. When the AI takes its next turn, the best (lowest) scored game state of the last batch of children will be attempted.

Another option was to sort the entire array of possible nodes including the new children, but there was no noticeable time saved, and the continuity is nice if you actually want to slow it down and watch the solution.

### Scoring a Node
The real magic of this is the scoring algorithm, which is very simple at its core. A node has a cost which is found by getting the cost of each stack in the game state. Each stack type has a `#score` method, but only the Tableau's is interesting (Foundations cost zero and Freecells cost an amount inverse to the card value).

Finding the cost of each Tableau considers some conditions for each card in the stack:
* If the card exists on the board at all it has a cost inverse with its value (as opposed to on a Foundation where every card costs zero)
  * Kings are worth the least the keep around, aces the most
  * At its simplest, if in the first move the AI can move an ace to the Foundation, it will, and will generate children from there
* If the card is not properly sorted with the card below it, it costs 10 more
  * This encourages stacks of completely sorted cards
* If the card is on the bottom of the stack, it has a cost inverse with its value
  * Again, Kings at the bottom of a stack cost nothing
  * This encourages starting Tableaus with as high a card as possible
* Finally, the card adds a `buried_value` to the entire stack if it's not sorted, and the higher the `buried_value`, the higher the cost of every card below it
  * This `buried_value` decreases with each card down so that removing the first card covering an ace is better than removing the third card covering an ace
  * If this were the case, the AI would go after the biggest stack first instead of tackling easier wins
  * The last change I made to this scoring algorithm was to add a `buried_value` for _every_ card, not just aces


```ruby
# tableau.rb
def score

  sum = 0
  max = 13
  buried_value = 0

  (0...@stack.length).each do |i|
    val = @stack[i].freecell_value

    sum += 10 * (max + 1 - val) # every card on the board is worth some points
    sum += 10 unless index_in_order?(i) # if not sorted with card above
    sum += 10 * (max - val) if i == 0 # bottom card in stack being too low

    if buried_value > 0 # add points to this card if it's on top of other lower cards
      sum += 10 * buried_value
      buried_value -= 1
    end

    # if this is an ace or low card, make other cards below cost more
    buried_value += max + 1 - val unless index_in_order?(i)

  end

  sum
end
```

The fun part about this solution is that improvements can be isolated to fine-tuning this single method. I'm sure there has been entire research papers done on the best way to score a Freecell game, but for now this homegrown solution works fairly well.

### Why a Node Graph
What makes this solver a node graph rather than a tree is that each child node is also stored in the `@graph` instance variable which contains a Hashmap of all GameNodes and which all GameNodes point to. To conserve memory, this variable exists in a single place in memory and is not duplicated for each new GameNode.

The reason I chose to implement a graph was to check the quickest discovered distance from the root node. If a child is created that already exists in `@graph`, its `@distance_from_root` variable is updated to the lowest available value. In this way, when the AI is done solving the game, it may have checked 1000 nodes, but found that the quickest way to a solution is only 200 nodes deep.
