This program implements an unbeatable Tic-Tac-Toe AI
in Ruby

_requires Ruby 1.9_

To play the game run `rake play`

To run the included unit tests run `rake test`

The implementation of the AI is explained in the comments
for `AIPlayer#get_move`

Changes in V3
=============
* Split source and test files into separate directories
* Rakefile now uses Rake::TestTask to run tests, much
  cleaner output
* All terminal IO is abstracted into Reader/Writer classes,
  allows much better test coverage and cleaner output
  (http://blog.8thlight.com/josh-cheek/2011/10/01/testing-code-thats-hard-to-test.html)

Changes in V2
=============

Rakefile
---------
* Now use `rake play` to play game, `rake test` to run tests
* Test coverage extended, includes testing methods that take
  user input (which puts a lot of garbage to the terminal
  but you can still see all the tests passing)

User Interface
--------------
* User now enters a cell number (0-8) instead of row/column
* Improved ANSI art with UTF-8 box symbols
* Slightly changed the user prompts

AIPlayer
------
* Now is its own class, does not inherit from player
* Move was only used by the AIPlayer so that class is now
  internal to the AIPlayer

Player
------
* Now prompts player for cell number 0-8
* No parts that are only necessary for the AIPlayer

Board
-----

* Current player now represented by a symbol :X or :O
* Board state representaion now 3x3 array of nil, :X, :O
  Much easier to understand
* Moves now made by row/column, only AIPlayer knows about Moves
* Simplified win/tie checking into one method
  Now returns :X, :O, :tie, :none; clearer meaning
* Made board larger, better looking, easier to read
* separated display of board from board class

Tic-Tac-Toe
-----------
* Separated different phases of game into their own methods
* Game now played by creating an instance of the TicTacToe class
* Made game logic easier to follow

Overall
-------
* Removed extraneous exceptions and state checking that never
  occur when playing the game
* Code easier to read and understand 

