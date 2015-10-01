Status = require('../scripts/ttt/status').Status
OppositeCornerStrategy = require('../scripts/ttt/opposite_corner').OppositeCornerStrategy

describe "Play the opposite corner", ->
  it "should reply with the opposite corner in bottom right", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ]

    strategy = new OppositeCornerStrategy()
    map[0][0] = Status.CROSS

    expect(strategy.getMove map, 0, 0).toEqual [2, 2]

  it "should reply with the opposite corner in top left", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ];

    strategy = new OppositeCornerStrategy();
    map[2][2] = Status.CROSS

    expect(strategy.getMove map, 2, 2).toEqual [0, 0]

  it "should reply with the opposite corner bottom left", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ];

    strategy = new OppositeCornerStrategy();
    map[0][2] = Status.CROSS

    expect(strategy.getMove map, 0, 2).toEqual [2, 0]

  it "should reply with the opposite corner bottom right", ->
    map = [
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
      [Status.EMPTY, Status.EMPTY, Status.EMPTY],
    ];

    strategy = new OppositeCornerStrategy();
    map[2][0] = Status.CROSS

    expect(strategy.getMove map, 2, 0).toEqual [0, 2]

