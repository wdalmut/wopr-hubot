# Description:
#   Check if raspberry correctly engaged with twitter
#

module.exports = (robot) ->
  robot.respond /ping[\?]?|hello[\.]?/i, (msg) ->
    pongs = [
      "Greetings professor Falken",
      "A strange game, the only winning move is not to play"
      "How about a nice game of chess?"
      "Shall we play a game?"
      "How are you feeling today?"
      "The only winning move is not to play"
    ]

    msg.send pongs[parseInt (Math.random() * 1e9) % pongs.length]
