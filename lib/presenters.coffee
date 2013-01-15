helpers = require "./helpers"

class Presenter
  constructor: (response, predictions) ->
    @response = response
    @predictions = predictions

  formatPrediction: (prediction) ->
    # Example implimentation
    "#{prediction.stopName}: #{prediction.estimate}"

  generateTitle: ->
    # Example implimentation
    "Predictions:"

  generateBody: ->
    # Example implimentation
    (@formatPrediction(prediction) for prediction in @predictions)

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
    unless @predictions.length > 0
        @response.status(404)
        @response.render 'error', {msg: 'No predictions available.'}
    else
      context = @generateTitle()
      context.predictions = @generateBody()
      @response.locals = context
      @response.render 'results', partials: {prediction: '_prediction'}

class SMSPresenter extends Presenter
  formatPrediction: (prediction) ->
    "In #{prediction.prediction.minutes}m: #{helpers.trimStopName prediction.stop.stopName}"

  generateTitle: ->
    "Rt #{@predictions[0].route.number}:"

  respond: ->
    unless @predictions.length > 0
      @response.send 200, "No predictions available."
    else
      message = @generateBody()
      message.unshift @generateTitle()
      message = message.join "\n"
      truncatedMessage = message.substring 0, 160
      console.warn "Outgoing message > 160 chars (#{message.length})" if truncatedMessage isnt message
      @response.send 200, truncatedMessage

module.exports = {WebPresenter, SMSPresenter}