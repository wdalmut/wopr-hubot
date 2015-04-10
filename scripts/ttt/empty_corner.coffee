Status = require('./status').Status

exports.EmptyCornerStrategy = class EmptyCornerStrategy
  getMove: (map, x, y) ->
    if map[0][0] == Status.EMPTY then return [0, 0]
    if map[0][2] == Status.EMPTY then return [0, 2]
    if map[2][0] == Status.EMPTY then return [2, 0]
    if map[2][2] == Status.EMPTY then return [2, 2]



