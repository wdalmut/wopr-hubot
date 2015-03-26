TicTacToe = require('../scripts/ttt/impl').TicTacToe
Status = require('../scripts/ttt/impl').Status

Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage

describe "tic tac toe robot integration", ->
  describe "Tic Tac Toe game", ->
    it "should prepare a new status", ->
      ttt = new TicTacToe
      for i in range = [0, 1, 2]
        for j in range = [0, 1, 2]
          expect(ttt.map[i][j]).toBe Status.EMPTY

    it "should place crosses and noughts", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT

      expect(ttt.map[0][0]).toBe Status.CROSS
      expect(ttt.map[0][1]).toBe Status.NOUGHT

    it "should thown exception on invalid moves", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT

      expect(() -> ttt.setStatus 0, 1, Status.CROSS).toThrow()

    it "should reply to a user move", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS

      ttt.replyTo 0, 0
      expect(ttt.map[1][1]).toBe Status.NOUGHT

    it "should block a user attack on a diagonal", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS

      ttt.replyTo 0, 0
      expect(ttt.map[2][2]).toBe Status.NOUGHT

    it "should block a user attack on a row", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 0, 1, Status.CROSS

      ttt.replyTo 0, 0
      expect(ttt.map[0][2]).toBe Status.NOUGHT

    it "should block a user attack on a column", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 1, 0, Status.CROSS

      ttt.replyTo 0, 0
      expect(ttt.map[2][0]).toBe Status.NOUGHT

    it "should draw the playground as text", ->
      ttt = new TicTacToe
      expect(ttt.draw()).toEqual """

      ◌|◌|◌
      -----
      ◌|◌|◌
      -----
      ◌|◌|◌

      """

    it "should draw the playground as text with crosses and noughts", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 2, 2, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT
      ttt.setStatus 0, 2, Status.NOUGHT
      ttt.setStatus 1, 2, Status.NOUGHT

      expect(ttt.draw()).toEqual """

      ✘|●|●
      -----
      ◌|✘|●
      -----
      ◌|◌|✘

      """

    it "should understand that there is a winning game by crosses by line", ->
      ttt = new TicTacToe
      ttt.setStatus 1, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 1, 2, Status.CROSS

      expect(ttt.isWon(Status.CROSS)).toBe true

    it "should understand that there is a winning game by crosses by column", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 1, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 2, 1, Status.CROSS

      expect(ttt.isWon(Status.CROSS)).toBe true

    it "should understand that there is a winning game by crosses", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 2, 2, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT
      ttt.setStatus 0, 2, Status.NOUGHT
      ttt.setStatus 1, 2, Status.NOUGHT

      expect(ttt.isWon(Status.CROSS)).toBe true

    it "should understand that there is a winning game by crosses [rev]", ->
      ttt = new TicTacToe
      ttt.setStatus 2, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 0, 2, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT
      ttt.setStatus 1, 2, Status.NOUGHT

      expect(ttt.isWon(Status.CROSS)).toBe true

    it "should understand that noughts lost", ->
      ttt = new TicTacToe
      ttt.setStatus 2, 0, Status.CROSS
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 0, 2, Status.CROSS
      ttt.setStatus 0, 1, Status.NOUGHT
      ttt.setStatus 1, 2, Status.NOUGHT

      expect(ttt.isWon(Status.NOUGHT)).toBe false

    it "should understand that we drew", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.NOUGHT
      ttt.setStatus 0, 1, Status.CROSS
      ttt.setStatus 0, 2, Status.NOUGHT
      ttt.setStatus 1, 0, Status.NOUGHT
      ttt.setStatus 1, 1, Status.CROSS
      ttt.setStatus 1, 2, Status.NOUGHT
      ttt.setStatus 2, 0, Status.CROSS
      ttt.setStatus 2, 1, Status.NOUGHT
      ttt.setStatus 2, 2, Status.CROSS

      expect(ttt.isDrew()).toBe true

    it "should understand that we are actually playing", ->
      ttt = new TicTacToe
      ttt.setStatus 0, 0, Status.NOUGHT
      ttt.setStatus 0, 1, Status.CROSS

      expect(ttt.isDrew()).toBe false
      expect(ttt.noMoreMoves()).toBe false


  describe "hubot tic tac toe engagement", ->
    beforeEach (done) ->
      @robot = new Robot null, "mock-adapter", false, "wopr"
      @robot.adapter.on "connected", ->
        require("../scripts/ttt")(@robot)
        @robot.brain.userForId "1", {
          name: "test"
          room: "#test"
        }
        @robot.brain.userForId "2", {
          name: "player"
          room: "#test"
        }

        ttt = new TicTacToe
        ttt.setStatus 0, 0, Status.CROSS
        @robot.brain.set "player_playground", ttt.map
        @robot.brain.save()

        done()

      @robot.run()

    afterEach ->
      @robot.shutdown()

    it "should prepare a new game", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual jasmine.any String
        expect(str[0].length).toBeGreaterThan 1
        done()

      user = @robot.brain.data.users["1"]
      @robot.adapter.receive(new TextMessage user, "@wopr play tic tac toe")

    it "should select a sentence war games sentence on 'hello'", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toMatch /^Hey test we are playing now on:/i
        done()

      user = @robot.brain.data.users["1"]
      @robot.adapter.receive(new TextMessage user, "@wopr play tic tac toe")

    it "should restore a previous game", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual """
        Hey player we are playing now on:
        ✘|◌|◌
        -----
        ◌|◌|◌
        -----
        ◌|◌|◌

        """
        done()

      user = @robot.brain.data.users["2"]
      @robot.adapter.receive(new TextMessage user, "@wopr play tic tac toe")

  describe "register actions and moves", ->
    beforeEach (done) ->
      @robot = new Robot null, "mock-adapter", false, "wopr"
      @robot.adapter.on "connected", ->
        require("../scripts/ttt")(@robot)
        @robot.brain.userForId "1", {
          name: "test"
          room: "#test"
        }
        @robot.brain.userForId "2", {
          name: "player"
          room: "#test"
        }
        @robot.brain.userForId "3", {
          name: "third"
          room: "#test"
        }
        @robot.brain.userForId "4", {
          name: "fourth"
          room: "#test"
        }

        ttt = new TicTacToe
        ttt.setStatus 0, 0, Status.CROSS
        ttt.setStatus 0, 1, Status.NOUGHT
        @robot.brain.set "player_playground", ttt.map
        ttt = new TicTacToe
        ttt.setStatus 0, 0, Status.CROSS
        ttt.setStatus 0, 1, Status.NOUGHT
        ttt.setStatus 0, 2, Status.NOUGHT
        ttt.setStatus 1, 0, Status.CROSS
        ttt.setStatus 1, 1, Status.CROSS
        ttt.setStatus 1, 2, Status.EMPTY
        ttt.setStatus 2, 0, Status.EMPTY
        ttt.setStatus 2, 1, Status.NOUGHT
        ttt.setStatus 2, 2, Status.NOUGHT
        @robot.brain.set "third_playground", ttt.map
        ttt = new TicTacToe
        ttt.setStatus 0, 0, Status.EMPTY
        ttt.setStatus 0, 1, Status.NOUGHT
        ttt.setStatus 0, 2, Status.NOUGHT
        ttt.setStatus 1, 0, Status.CROSS
        ttt.setStatus 1, 1, Status.CROSS
        ttt.setStatus 1, 2, Status.EMPTY
        ttt.setStatus 2, 0, Status.EMPTY
        ttt.setStatus 2, 1, Status.EMPTY
        ttt.setStatus 2, 2, Status.EMPTY
        @robot.brain.set "fourth_playground", ttt.map
        @robot.brain.save()

        done()

      @robot.run()

    afterEach ->
      @robot.shutdown()

    xit "should try to win first", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual """

        ●|●|●
        -----
        ◌|✘|✘
        -----
        ◌|◌|✘

        """
        done()

      user = @robot.brain.data.users["4"]
      @robot.adapter.receive(new TextMessage user, "@wopr tick 3 3")

    it "should reply that a user won", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual """
        You win!!!
        ✘|●|●
        -----
        ✘|✘|✘
        -----
        ●|●|●

        """
        done()

      user = @robot.brain.data.users["3"]
      @robot.adapter.receive(new TextMessage user, "@wopr tick 2 3")

    it "should store and reply to other moves", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual """

        ✘|●|◌
        -----
        ◌|✘|◌
        -----
        ◌|◌|●

        """
        done()

      user = @robot.brain.data.users["2"]
      @robot.adapter.receive(new TextMessage user, "@wopr tick 2 2")

    it "should reply that we drew", (done) ->
      @robot.adapter.on "send", (env, str) ->
        expect(str[0]).toEqual """
        You win!!!
        ✘|●|●
        -----
        ✘|✘|✘
        -----
        ●|●|●

        """
        done()

      user = @robot.brain.data.users["3"]
      @robot.adapter.receive(new TextMessage user, "@wopr tick 2 3")

