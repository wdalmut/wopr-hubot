# Description:
#   Show actual IPs on the Raspberry Pi
#
# Notes:
#   Sometime is very difficult to understand the raspberry position
#

os = require 'os'

module.exports = (robot) ->
  robot.respond /where are you(\?)?/i, (msg) ->
    ifaces = os.networkInterfaces()

    lines = []
    for name, iface of ifaces when name != 'lo'
      for ipv4 in iface when ipv4.family == 'IPv4'
        lines.push "network '#{name}' with address '#{ipv4.address}'"

    msg.send lines.join("\n")
