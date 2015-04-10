Status = require('./status').Status

BlockStrategy = require('./block_strategy').BlockStrategy
AttackStrategy = require('./attack_strategy').AttackStrategy
FirstEmptyStrategy = require('./first_empty_strategy').FirstEmptyStrategy
PlayTheCenterStrategy = require('./play_the_center').PlayTheCenterStrategy
OppositeCornerStrategy = require('./opposite_corner').OppositeCornerStrategy
EmptyCornerStrategy = require('./empty_corner').EmptyCornerStrategy

exports.TicTacToe = class TicTacToe
  constructor: () ->
    @map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ]
    @fallbackStrategies = [
      new BlockStrategy(),
      new AttackStrategy(),
      new PlayTheCenterStrategy(),
      new OppositeCornerStrategy(),
      new EmptyCornerStrategy(),
      new FirstEmptyStrategy(),
    ]

  setStatus: (x, y, status) ->
    if @map[x][y] != Status.EMPTY
      throw new Error "You can't do that! #{x}, #{y} -> #{@map[x][y]}"
    else
      @map[x][y] = status

  replyTo: (x, y) ->
    [i, j] = @getMove x, y
    @setStatus i, j, Status.NOUGHT

  getMove: (x, y) ->
    for strategy in @fallbackStrategies
      if pos = strategy.getMove @map, x, y then return pos

    throw new Error "No one strategy found..."

  hasWon: (symbol) ->
    lineWon = (line) =>
      for j in [0, 1, 2]
        if @map[line][j] != symbol
          return false
      return true

    columnWon = (column) =>
      for j in [0, 1, 2]
        if @map[j][column] != symbol
          return false
      return true

    diagonalWon = () =>
      for i in [0, 1, 2]
        if @map[i][i] != symbol
          return false

      return true

    reverseDiagonalWon = () =>
      for i in [2, 1, 0]
        if @map[i][Math.abs(i-2)] != symbol
          return false

      return true

    for i in [0, 1, 2]
      if lineWon(i) then return true
      if columnWon(i) then return true
      if diagonalWon() then return true
      if reverseDiagonalWon() then return true

    return false

  noMoreMoves: () ->
    for i in [0, 1, 2]
      for j in [0, 1, 2]
        if @map[i][j] == Status.EMPTY then return false
    return true

  weDrew: () ->
    if @noMoreMoves() and not @hasWon Status.CROSS and not @hasWon Status.NOUGHT then true else false

  draw: () ->
    playground = ["\n"]
    for i in [0, 1, 2]
      line = []
      for j in [0, 1, 2]
        line.push switch
          when @map[i][j] == Status.EMPTY then "◌"
          when @map[i][j] == Status.CROSS then "✘"
          when @map[i][j] == Status.NOUGHT then "●"

      playground.push line.join "|"
      playground.push "\n"

      if i != 2 then playground.push "-----\n"

    playground.join("")

