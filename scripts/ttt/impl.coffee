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
    [i, j] = @getMove x, y
    @setStatus i, j, Status.NOUGHT

  getMove: (x, y) ->
    if ret = @getBestMove x, y, Status.CROSS, Status.NOUGHT
      return ret
    else
      if ret = @getBestMove x, y, Status.NOUGHT, Status.CROSS
        return ret

    @getFirstEmptyCell x, y

  getBestMove: (x, y, check, apply) ->
    for i in [0, 1, 2]
      for j in [0, 1, 2]
        if @map[i][j] == check
          break
        else
          if @map[i][j] == Status.EMPTY
            if @map[i][(j+1)%3] == apply and @map[i][(j+2)%3] == apply then return [i, j]

    for j in [0, 1, 2]
      for i in [0, 1, 2]
        if @map[i][j] == check
          break
        else
          if @map[i][j] == Status.EMPTY
            if @map[(i+1)%3][j] == apply and @map[(i+2)%3][j] == apply then return [i, j]

    for i in [0, 1, 2]
      if @map[i][i] == check
        break
      else
        if @map[i][i] == Status.EMPTY
          if @map[(i+1)%3][(i+1)%3] == apply and @map[(i+2)%3][(i+2)%3] == apply then return [i, i]

    for [i, j] in [[2, 0], [1, 1], [0, 2]]
      if @map[i][j] == check
        break
      else
        if @map[i][i] == Status.EMPTY
          if @map[(i+1)%3][(j+1)%3] == apply and @map[(i+2)%3][(j+2)%3] == apply then return [i, j]

  getFirstEmptyCell: (x, y) ->
    for i in [1, 2, 3]
      for j in [1, 2, 3]
        if i is 3 and j is 3 then continue
        if @map[(x+i)%3][(y+j)%3] == Status.EMPTY
          return [(x+i)%3, (y+j)%3]

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

