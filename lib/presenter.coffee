module.exports =
  formatAsSMS: (predictions) ->
    return [false, "Error: No predictions available"] unless predictions.length > 0
    response = []
    SMSformatHeader(predictions[0], response)
    (SMSformatPrediction(p, response) for p in predictions)
    [true, response.join("\n")]

SMSformatHeader = (prediction, response) ->
  response.push "Rt #{prediction.route.number}:"

SMSformatPrediction = (prediction, response) ->
  response.push "In #{prediction.prediction.minutes}m: #{trimStopName prediction.stop.stopName}"

trimStopName = (stopName) ->
  stopName.replace(/(?:^.*&\s)(\w*)/gim, "$1")
