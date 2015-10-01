Status = require('./status').Status

exports.PlayTheCenterStrategy = class PlayTheCenterStrategy
  getMove: (map, x, y) ->
    if map[2][2] == Status.EMPTY then return [2, 2]

