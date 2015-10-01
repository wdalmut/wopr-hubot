Status = require('./status').Status

exports.BlockAttackStrategy = class BlockAndAttackStrategy
  constructor: (@check, @apply) ->

  getMove: (map, x, y) ->
    for i in [0, 1, 2]
      for j in [0, 1, 2]
        if map[i][j] == @check
          break
        else
          if map[i][j] == Status.EMPTY
            if map[i][(j+1)%3] == @apply and map[i][(j+2)%3] == @apply then return [i, j]

    for j in [0, 1, 2]
      for i in [0, 1, 2]
        if map[i][j] == @check
          break
        else
          if map[i][j] == Status.EMPTY
            if map[(i+1)%3][j] == @apply and map[(i+2)%3][j] == @apply then return [i, j]

    for i in [0, 1, 2]
      if map[i][i] == @check
        break
      else
        if map[i][i] == Status.EMPTY
          if map[(i+1)%3][(i+1)%3] == @apply and map[(i+2)%3][(i+2)%3] == @apply then return [i, i]

    for [i, j] in [[2, 0], [1, 1], [0, 2]]
      if map[i][j] == @check
        break
      else
        if map[i][i] == Status.EMPTY
          if map[(i+1)%3][(j+1)%3] == @apply and map[(i+2)%3][(j+2)%3] == @apply then return [i, j]

