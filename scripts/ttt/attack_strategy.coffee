Status = require('./status').Status
BlockAttackStrategy = require('./block_attack_strategy').BlockAttackStrategy

exports.AttackStrategy = class AttackStrategy extends BlockAttackStrategy
  constructor: ->
    super(Status.CROSS, Status.NOUGHT)


