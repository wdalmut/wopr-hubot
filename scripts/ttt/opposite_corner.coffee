Status = require('./status').Status

exports.OppositeCornerStrategy = class OppositeCornerStrategy
  getMove: (map, x, y) ->
    if x == 0 and y == 0 and map[2][2] == Status.EMPTY then return [2, 2]
    if x == 2 and y == 2 and map[0][0] == Status.EMPTY then return [0, 0]
    if x == 0 and y == 2 and map[2][0] == Status.EMPTY then return [2, 0]
    if x == 2 and y == 0 and map[0][2] == Status.EMPTY then return [0, 2]

