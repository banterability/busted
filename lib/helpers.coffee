module.exports =
  trimStopName: (stopName) ->
    stopName.replace /(?:^.*&\s)(\w*)/gim, "$1"

  extractBusNumber: (text="") ->
    text.match(/(\d+)/)?[1]

  calculatePercentComplete: (minutes) ->
    return 0 if minutes > 10
    100 - (minutes/10) * 100
