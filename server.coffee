express = require 'express'

parser = require './lib/parser'
client = require './lib/client'
presenter = require './lib/presenter'
helpers = require "./lib/helpers"

throw "Nodefly API Key not configured! ($NODEFLY_API_KEY)" unless process.env.NODEFLY_API_KEY
require('nodefly').profile(
  process.env.NODEFLY_API_KEY,
  'Busted',
  {}
)

app = express()

app.set 'view engine', 'mustache'
app.set 'layout', 'layout'
# app.set 'partials', head: 'head'
app.enable 'view cache' if app.settings.env is "production"
app.engine 'mustache', require 'hogan-express'

app.use express.bodyParser()

throw "CTA API Key not configured! ($CTA_API_KEY)" unless process.env.CTA_API_KEY
app.set 'apiKey', process.env.CTA_API_KEY

app.get "/route/:routeId", (req, res) ->
  console.log "Incoming Web: ", req.params
  res.set "Content-Type", "text/html"

  busNumber = req.params["routeId"]

  client.fetchPredictions busNumber, app.get('apiKey'), (results) ->
    predictions = parser.fromServer(results)
    [success, context] = presenter.formatAsHTML(predictions)
    if success then status = 200 else status = 404
    context.title = "Route #{busNumber}"

    options = {res, status, context}
    options.template = 'htmlResponse'
    options.partials = {prediction: '_prediction'}
    renderHTML(options)

app.post "/sms/", (req, res) ->
  console.log "Incoming SMS: ", req.body
  res.set "Content-Type", "text/plain"

  busNumber = helpers.extractBusNumber(req.body.Body || "")

  if busNumber
    client.fetchPredictions busNumber, app.get('apiKey'), (results) ->
        predictions = parser.fromServer(results)
        [success, message] = presenter.formatAsSMS(predictions)
        if success then status = 200 else status = 404
        renderSMS res, status, message
  else
    renderSMS res, 400, "Error: Your message must include a bus number"

renderSMS = (res, status, message) ->
  console.log "[Resposne (SMS)]: ", {status, message}
  truncatedMessage = message.substring 0, 160
  if truncatedMessage isnt message
    console.error "Outgoing message exceeds 160 characters (#{message.length}); truncating..."
  res.send 200, truncatedMessage # Always send 200, or Twilio won't send an SMS

renderHTML = ({res, template, partials, status, context}) ->
  console.log "[Resposne (Web)]: ", {template, status, context, partials}
  res.locals = context
  res.render template, partials: partials

port = process.env.PORT || 5000
app.listen port, ->
  console.log "Server up on port #{port}"
