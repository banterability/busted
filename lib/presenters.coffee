helpers = require "./helpers"

class Presenter
  constructor: (response, predictions) ->
    @response = response
    @predictions = predictions

  buildPredictionList: ->
    @formatPrediction(prediction) for prediction in @predictions

  formatPrediction: (prediction) ->
    throw "Method not implemented: #formatPrediction"

class WebPresenter extends Presenter
  formatPrediction: (prediction) ->
    stopName: helpers.trimStopName prediction.stop.stopName
    estimate: prediction.prediction.minutes
    percentComplete: helpers.calculatePercentComplete(prediction.prediction.minutes)

  buildGeneralContext: ->
    routeNumber: @predictions[0].route.number
    routeDirection: @predictions[0].route.direction
    busNumber: @predictions[0].busNumber

  respond: ->
    if @predictions.length > 0
      context = @buildGeneralContext()
      context.predictions = @buildPredictionList()
      @response.locals = context
      @response.render 'results', partials: {prediction: '_prediction'}
    else
      @response.status(404)
      @response.render 'error', {msg: 'No predictions available.'}

class SMSPresenter extends Presenter
  formatPrediction: (prediction) ->
    "In #{prediction.prediction.minutes}m: #{helpers.trimStopName prediction.stop.stopName}"

  buildTitle: ->
    "Rt #{@predictions[0].route.number}:"

  respond: ->
    if @predictions.length > 0
      message = @buildPredictionList()
      message.unshift @buildTitle()
      message = message.join "\n"
      truncatedMessage = message.substring 0, 160
      console.warn "Outgoing message > 160 chars (#{message.length})" if truncatedMessage isnt message
      @response.send 200, truncatedMessage
    else
      @response.send 200, "No predictions available."

module.exports = {WebPresenter, SMSPresenter}