os = require 'os'

Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage

describe "test", ->
  beforeEach (done) ->
    @robot = new Robot null, "mock-adapter", false, "wopr"
    @robot.adapter.on "connected", ->
      require("../scripts/ip")(@robot)
      @user = @robot.brain.userForId "1", {
        name: "test"
        room: "#test"
      }

      done()

    @robot.run()

  afterEach ->
    @robot.shutdown()

  it "should show actual ip addresses", (done) ->
    @robot.adapter.on "send", (env, str) ->
      expect(str[0]).toMatch /network '(\w+)' with address '(.*)'/i
      done()

    user = @robot.brain.data.users["1"]
    @robot.adapter.receive(new TextMessage user, "@wopr where are you?")

  it "should skip the loopback address", (done) ->
    spyOn(os, "networkInterfaces").and.returnValue {
      lo: [ { address: '127.0.0.1', family: 'IPv4', internal: true }, { address: '::1', family: 'IPv6', internal: true } ],
    }

    @robot.adapter.on "send", (env, str) ->
      expect(str[0]).toMatch ""
      done()

    user = @robot.brain.data.users["1"]
    @robot.adapter.receive(new TextMessage user, "@wopr where are you?")

  it "should show only IPv4 networks", (done) ->
    spyOn(os, "networkInterfaces").and.returnValue {
      lo: [ { address: '127.0.0.1', family: 'IPv4', internal: true }, { address: '::1', family: 'IPv6', internal: true } ],
      wlan0: [ { address: '192.168.1.100', family: 'IPv4', internal: false }, { address: 'fe80::aed:b9ff:feba:f30d', family: 'IPv6', internal: false } ],
      docker0: [ { address: '172.17.42.1', family: 'IPv4', internal: false }, { address: 'fe80::5484:7aff:fefe:9799', family: 'IPv6', internal: false } ],
      vethea41c86: [ { address: 'fe80::8c08:5ff:fed1:7a71', family: 'IPv6', internal: false } ]
    }

    @robot.adapter.on "send", (env, str) ->
      expect(str[0]).toMatch /^network 'wlan0' with address '192\.168\.1\.100'\nnetwork 'docker0' with address '172.17.42.1'$/
      done()

    user = @robot.brain.data.users["1"]
    @robot.adapter.receive(new TextMessage user, "@wopr where are you?")


