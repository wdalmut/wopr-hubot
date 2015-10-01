Status = require('./status').Status

exports.FirstEmptyStrategy = class FirstEmptyStrategy
  getMove: (map, x, y) ->
    for i in [1, 2, 3]
      for j in [1, 2, 3]
        if i is 3 and j is 3 then continue
        if map[(x+i)%3][(y+j)%3] == Status.EMPTY
          return [(x+i)%3, (y+j)%3]






