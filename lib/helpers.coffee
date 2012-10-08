module.exports =
  trimStopName: (stopName) ->
    stopName.replace /(?:^.*&\s)(\w*)/gim, "$1"
