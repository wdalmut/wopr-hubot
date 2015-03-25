exports.Status = Status =
  EMPTY : 0
  CROSS: 1
  NOUGHT: 2

exports.TicTacToe = class TicTacToe
  constructor: () ->
    @map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ]

  setStatus: (x, y, status) ->
    if @map[x][y] != Status.EMPTY
      throw new Error "You can't do that! #{x}, #{y} -> #{@map[x][y]}"
    else
      @map[x][y] = status

  replyTo: (x, y) ->
    [i, j] = @getBestBlockMove x, y
    @setStatus i, j, Status.NOUGHT

  getBestBlockMove: (x, y) ->
    r = 0; c = 0
    for i in [1, 2, 3]
      for j in [1, 2, 3]
        if i is 3 and j is 3 then continue
        if @map[(x+i)%3][(y+j)%3] == Status.CROSS
          if x != (x+i)%3 then r = (x+i+1)%3
          if y != (y+j)%3 then c = (y+j+1)%3
          if @map[r][c] == Status.EMPTY then return [r, c]
    @getFirstEmptyCell x, y

  getFirstEmptyCell: (x, y) ->
    for i in [1, 2, 3]
      for j in [1, 2, 3]
        if i is 3 and j is 3 then continue
        if @map[(x+i)%3][(y+j)%3] == Status.EMPTY
          return [(x+i)%3, (y+j)%3]

  isWon: (symbol) ->
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

  isDrew: () ->
    if @noMoreMoves() and not @isWon Status.CROSS and not @isWon Status.NOUGHT then true else false

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

