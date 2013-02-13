if process.env.NODE_ENV is "production"
  throw "Nodefly API Key not configured! ($NODEFLY_API_KEY)" unless process.env.NODEFLY_API_KEY
  require('nodefly').profile(
    process.env.NODEFLY_API_KEY,
    'Busted',
    {}
  )

express = require 'express'
_ = require 'underscore'

profiler = require('./lib/profiler')()
parser = require './lib/parser'
Client = require './lib/client'
{WebPresenter, SMSPresenter} = require './lib/presenters'
helpers = require "./lib/helpers"
logger = require "./lib/logger"

# Configuration

app = express()
app.set 'view engine', 'mustache'
app.set 'layout', 'layout'
# app.set 'partials', head: 'head'
app.engine 'mustache', require 'hogan-express'

profiler.on 'profile', (profileObject, req, res) ->
  _.extend profileObject,
    remoteAddress: req.connection.remoteAddress
    method: req.method
    url: req.url
    status: res.statusCode
    logType: 'web'

  logger.info 'web', profileObject

app.use profiler.middleware
app.use "/assets", express.static "#{__dirname}/public"
app.use express.bodyParser()

throw "CTA API Key not configured! ($CTA_API_KEY)" unless process.env.CTA_API_KEY
app.set 'apiKey', process.env.CTA_API_KEY

if app.settings.env is "production"
  app.enable 'view cache'

# Routes

app.get "/", (req, res) ->
  res.render 'index'

app.get "/route/:routeId", (req, res) ->
  res.set "Content-Type", "text/html"

  busNumber = req.params["routeId"]

  client = new Client {apiKey: app.get('apiKey')}
  client.getPredictions busNumber, (results) ->
    predictions = parser.fromServer(results)
    new WebPresenter(res, predictions).respond()

app.post "/sms/", (req, res) ->
  res.set "Content-Type", "text/plain"

  busNumber = helpers.extractBusNumber(req.body.Body || "")

  return res.send 200, "Error: Your message must include a bus number" unless busNumber

  client = new Client {apiKey: app.get('apiKey')}
  client.getPredictions busNumber, (results) ->
      predictions = parser.fromServer(results)
      new SMSPresenter(res, predictions).respond()

port = process.env.PORT || 5000
app.listen port, ->
  logger.info "Server up on port #{port}"
