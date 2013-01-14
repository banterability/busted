express = require 'express'

parser = require './lib/parser'
Client = require './lib/client'
presenter = require './lib/presenter'
helpers = require "./lib/helpers"

# Configuration

app = express()
app.set 'view engine', 'mustache'
app.set 'layout', 'layout'
# app.set 'partials', head: 'head'
app.engine 'mustache', require 'hogan-express'
app.use express.bodyParser()
app.use "/assets", express.static "#{__dirname}/public"

throw "CTA API Key not configured! ($CTA_API_KEY)" unless process.env.CTA_API_KEY
app.set 'apiKey', process.env.CTA_API_KEY

if app.settings.env is "production"
  app.enable 'view cache'

  throw "Nodefly API Key not configured! ($NODEFLY_API_KEY)" unless process.env.NODEFLY_API_KEY
  require('nodefly').profile(
    process.env.NODEFLY_API_KEY,
    'Busted',
    {}
  )

# Routes

app.get "/", (req, res) ->
  renderHTML
    res: res
    template: 'index'
    status: 200

app.get "/route/:routeId", (req, res) ->
  console.log "Incoming Web: ", req.params
  res.set "Content-Type", "text/html"

  busNumber = req.params["routeId"]

  client = new Client {apiKey: app.get('apiKey')}
  client.getPredictions busNumber, (results) ->
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
    client = new Client {apiKey: app.get('apiKey')}
    client.getPredictions busNumber, (results) ->
        predictions = parser.fromServer(results)
        [success, message] = presenter.formatAsSMS(predictions)
        if success then status = 200 else status = 404
        renderSMS res, status, message
  else
    renderSMS res, 400, "Error: Your message must include a bus number"

# Helpers

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

# Start server

port = process.env.PORT || 5000
app.listen port, ->
  console.log "Server up on port #{port}"
