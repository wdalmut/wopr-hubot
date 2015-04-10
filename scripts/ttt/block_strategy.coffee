Status = require('./status').Status
BlockAttackStrategy = require('./block_attack_strategy').BlockAttackStrategy

exports.BlockStrategy = class BlockStrategy extends BlockAttackStrategy
  constructor: ->
    super(Status.NOUGHT, Status.CROSS)

