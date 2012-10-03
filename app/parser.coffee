fs = require "fs"
et = require "elementtree"

module.exports.fromExample = ->
  fs.readFile "example.xml", "utf-8", (err, data) ->
    return console.error("Couldn't read file", err) if err
    extractPredictionsFromData(data)

module.exports.fromServer = (data) ->
  extractPredictionsFromData(data)

extractPredictionsFromData = (data) ->
    etree = et.parse(data)
    predictions = etree.findall('./prd')
    (buildPrediction(result) for result in predictions)

buildPrediction = (tree) ->
  payload =
    busNumber: getNodeFromTree 'vid', tree
    prediction:
      predictedFor: getTimeNodeFromTree 'prdtm', tree
      generatedAt: getTimeNodeFromTree 'tmstmp', tree
      type: getPredictionType tree
      delayed: getBooleanNodeFromTree 'dly', tree
      distanceAway: getNodeFromTree 'dstp', tree
    route:
      number: getNodeFromTree 'rt', tree
      direction: getNodeFromTree 'rtdir', tree
      destination: getNodeFromTree 'rtdst', tree
    stop:
      stopId: getNodeFromTree 'stpid', tree
      stopName: getNodeFromTree 'stpnm', tree

  payload.prediction.minutes = getMinutesRemaining payload.prediction.generatedAt, payload.prediction.predictedFor
  payload

findNodeInTree = (node, tree) ->
  tree.find(node)

getNodeFromTree = (node, tree) ->
  node = findNodeInTree node, tree
  return undefined unless node
  node.text

getPredictionType = (tree) ->
  type = getNodeFromTree 'typ', tree
  if type is 'A'
    'arrival'
  else
    'departure'

getBooleanNodeFromTree = (node, tree) ->
  boolNode = findNodeInTree node, tree
  return false unless boolNode
  boolNode.text is true

getTimeNodeFromTree = (node, tree) ->
  node = getNodeFromTree(node, tree)
  return undefined unless node
  parseTime node

parseTime = (timeString) ->
  [str, year, month, day, hour, min] = timeString.match /(\d{4})(\d{2})(\d{2}) (\d{2}):(\d{2})/
  new Date year, month-1, day, hour, min

getMinutesRemaining = (startDate, endDate) ->
  return undefined unless startDate and endDate
  (endDate - startDate) / (60 * 1000)
