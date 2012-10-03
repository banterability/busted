module.exports.format = (predictions) ->
  return [false, "Error: No predictions available"] unless predictions.length > 0
  response = []
  formatHeader(predictions[0], response)
  (formatPrediction(p, response) for p in predictions)
  [true, response.join("\n")]

formatHeader = (prediction, response) ->
  response.push "Rt #{prediction.route.number}:"

formatPrediction = (prediction, response) ->
  response.push "In #{prediction.prediction.minutes}m: #{prediction.stop.stopName}"
