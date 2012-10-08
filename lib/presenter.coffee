helpers = require "./helpers"

module.exports =
  formatAsHTML: (predictions) ->
    return [false, "Error: No predictions available"] unless predictions.length > 0
    response = {}
    response.predictions = []
    HTMLformatHeader(predictions[0], response)
    (HTMLformatPrediction(p, response) for p in predictions)
    [true, response]

  formatAsSMS: (predictions) ->
    return [false, "Error: No predictions available"] unless predictions.length > 0
    response = []
    SMSformatHeader(predictions[0], response)
    (SMSformatPrediction(p, response) for p in predictions)
    [true, response.join("\n")]

SMSformatHeader = (prediction, response) ->
  response.push "Rt #{prediction.route.number}:"

SMSformatPrediction = (prediction, response) ->
  response.push "In #{prediction.prediction.minutes}m: #{helpers.trimStopName prediction.stop.stopName}"

HTMLformatHeader = (prediction, response) ->
  response.routeNumber = prediction.route.number
  response.routeDirection = prediction.route.direction

HTMLformatPrediction = (prediction, response) ->
  returnValue =
    stopName: helpers.trimStopName prediction.stop.stopName
    estimate: prediction.prediction.minutes
    percentComplete: calculatePercentComplete(prediction.prediction.minutes)
  console.log "prediction: ", returnValue
  response.predictions.push returnValue

calculatePercentComplete = (minutes) ->
  return 0 if minutes > 10
  100 - (minutes/10) * 100
