os = require 'os'

Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage

describe "test reply to user pings", ->
  beforeEach (done) ->
    @robot = new Robot null, "mock-adapter", false, "wopr"
    @robot.adapter.on "connected", ->
      require("../scripts/ping")(@robot)
      @user = @robot.brain.userForId "1", {
        name: "test"
        room: "#test"
      }

      done()

    @robot.run()

  afterEach ->
    @robot.shutdown()

  it "should select a sentence war games sentence on 'ping'", (done) ->
    @robot.adapter.on "send", (env, str) ->
      expect(str[0]).toEqual jasmine.any String
      expect(str[0].length).toBeGreaterThan 1
      done()

    user = @robot.brain.data.users["1"]
    @robot.adapter.receive(new TextMessage user, "@wopr ping")

  it "should select a sentence war games sentence on 'hello'", (done) ->
    @robot.adapter.on "send", (env, str) ->
      expect(str[0]).toEqual jasmine.any String
      expect(str[0].length).toBeGreaterThan 1
      done()

    user = @robot.brain.data.users["1"]
    @robot.adapter.receive(new TextMessage user, "@wopr hello")
