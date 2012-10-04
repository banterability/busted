express = require 'express'
parser = require './lib/parser'
client = require './lib/client'
presenter = require './lib/presenter'

app = express()
app.use express.bodyParser()
throw "API Key not configured! ($BUSTRACKER_API_KEY)" unless process.env.BUSTRACKER_API_KEY
app.set 'apiKey', process.env.BUSTRACKER_API_KEY

app.post "/sms/", (req, res) ->
  console.log "Incoming SMS: ", req.body
  res.set "Content-Type", "text/plain"

  busNumber = extractBusNumber(req.body.Body || "")

  if busNumber
    client.fetchPredictions busNumber, app.get('apiKey'), (results) ->
        predictions = parser.fromServer(results)
        [success, message] = presenter.format(predictions)
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

extractBusNumber = (string) ->
  string.match(/(\d+)/)?[1]

port = process.env.PORT || 5000
app.listen port, ->
  console.log "Server up on port #{port}"
