# Description:
#   Check if raspberry correctly engaged with twitter
#
TicTacToe = require('../scripts/ttt/impl').TicTacToe
Status = require('../scripts/ttt/status').Status

module.exports = (robot) ->
  robot.respond /(play)?[ ]?(tic tac toe|ttt)/i, (msg) ->

    user = msg.message.user.user
    line = "Hey #{user} we are playing now on:"

    ttt = new TicTacToe
    playground = robot.brain.get "#{user}_playground"

    if playground
      ttt.map = playground
    else
      row = parseInt Math.random() * 1e9 % 3
      col = parseInt Math.random() * 1e9 % 3

      ttt.setStatus row, col, Status.NOUGHT

      robot.brain.set "#{user}_playground", ttt.map

    msg.send line + ttt.draw()

  robot.respond /(sign|play|tick|mark|put) ([1-3]{1}) ([1-3]{1})/i, (msg) ->
    [all, command, row, col] = msg.match

    user = msg.message.user.user

    ttt = new TicTacToe
    playground = robot.brain.get "#{user}_playground"
    ttt.map = playground

    try
      ttt.setStatus row-1, col-1, Status.CROSS
      ttt.replyTo row-1, col-1

      robot.brain.set "#{user}_playground", ttt.map

      line = ""
      if ttt.hasWon Status.CROSS
        line = "You win!!!"
        robot.brain.remove "#{user}_playground"
      else if ttt.hasWon Status.NOUGHT
        line ="You lost!!!"
        robot.brain.remove "#{user}_playground"
      else if ttt.weDrew()
        line = "A strange game, the only winning move is not to play"
        robot.brain.remove "#{user}_playground"

      msg.send line + ttt.draw()
    catch error
      msg.send "Hey -> #{error.message}"

