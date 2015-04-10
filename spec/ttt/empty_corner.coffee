Status = require('../scripts/ttt/status').Status
EmptyCorner = require('../scripts/ttt/empty_corner').EmptyCornerStrategy

describe "Play a corner", ->
  it "should reply with a corner: top right", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ]

    strategy = new EmptyCorner()

    map[0][0] = Status.NOUGHT

    expect(strategy.getMove map, 0, 0).toEqual [0, 2]

  it "should reply with a corner: top left", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ]

    strategy = new EmptyCorner()

    map[0][2] = Status.NOUGHT

    expect(strategy.getMove map, 0, 2).toEqual [0, 0]
