express = require 'express'
parser = require './lib/parser'
client = require './lib/client'
presenter = require './lib/presenter'

app = express()

app.set 'view engine', 'mustache'
# app.set 'layout', 'layout'
# app.set 'partials', head: 'head'
# app.enable 'view cache'
app.engine 'mustache', require 'hogan-express'

app.use express.bodyParser()

throw "API Key not configured! ($BUSTRACKER_API_KEY)" unless process.env.BUSTRACKER_API_KEY
app.set 'apiKey', process.env.BUSTRACKER_API_KEY

app.get "/route/:routeId", (req, res) ->
  console.log "Incoming Web: ", req.params
  res.set "Content-Type", "text/html"

  busNumber = req.params["routeId"]

  client.fetchPredictions busNumber, app.get('apiKey'), (results) ->
    predictions = parser.fromServer(results)
    [success, context] = presenter.formatAsHTML(predictions)
    if success then status = 200 else status = 404
    respondWithHTML res, status, context

app.post "/sms/", (req, res) ->
  console.log "Incoming SMS: ", req.body
  res.set "Content-Type", "text/plain"

  busNumber = extractBusNumber(req.body.Body || "")

  if busNumber
    client.fetchPredictions busNumber, app.get('apiKey'), (results) ->
        predictions = parser.fromServer(results)
        [success, message] = presenter.formatAsSMS(predictions)
        if success then status = 200 else status = 404
        respondWithSMS res, status, message
  else
    respondWithSMS res, 400, "Error: Your message must include a bus number"

respondWithSMS = (res, status, message) ->
  console.log "Outgoing SMS: ", {status, message}
  truncatedMessage = message.substring 0, 160
  if truncatedMessage isnt message
    console.error "Outgoing message exceeds 160 characters (#{message.length}); truncating..."
  res.send(200, truncatedMessage) # Always send 200, or Twilio won't send an SMS

respondWithHTML = (res, status, context) ->
  console.log "Outgoing Web: ", {status, context}
  res.locals = context
  res.render 'htmlResponse', partials: {prediction: 'prediction'}

extractBusNumber = (string) ->
  string.match(/(\d+)/)?[1]

port = process.env.PORT || 5000
app.listen port, ->
  console.log "Server up on port #{port}"
