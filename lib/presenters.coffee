helpers = require "./helpers"

class Presenter
  constructor: (predictions) ->
    @predictions = predictions

  formatPrediction: (prediction) ->
    # Example implimentation
    "#{prediction.stopName}: #{prediction.estimate}"

  generateTitle: ->
    # Example implimentation
    "Predictions:"

  generateBody: ->
    (@formatPrediction(prediction) for prediction in @predictions).join "\n"

  respond: ->
    # Returns [success, response], where
    # - success:
    #   true or false
    #
    # - response:
    #   A string representation to return to the client
    #
    # Example implimentation
    [true, @generateBody()]

class WebPresenter extends Presenter
  formatPrediction: (prediction) ->
    stopName: helpers.trimStopName prediction.stop.stopName
    estimate: prediction.prediction.minutes
    percentComplete: helpers.calculatePercentComplete(prediction.prediction.minutes)

  generateTitle: ->
    routeNumber: @predictions[0].route.number
    routeDirection: @predictions[0].route.direction
    busNumber: @predictions[0].busNumber

  respond: ->
    # return [false, "Error: No predictions available"] unless predictions.length > 0
    # response = {}
    # response.predictions = []
    # HTMLformatHeader(predictions[0], response)
    # (HTMLformatPrediction(p, response) for p in predictions)
    # [true, response]

class SMSPresenter extends Presenter
  formatPrediction: (prediction) ->
    "In #{prediction.prediction.minutes}m: #{helpers.trimStopName prediction.stop.stopName}"

  generateTitle: ->
    "Rt #{@predictions[0].route.number}:"

  respond: ->
    # return [false, "Error: No predictions available"] unless predictions.length > 0
    # response = []
    # SMSformatHeader(predictions[0], response)
    # (SMSformatPrediction(p, response) for p in predictions)
    # [true, response.join("\n")]

module.exports = {WebPresenter, SMSPresenter}