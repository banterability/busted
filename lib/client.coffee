request = require 'request'
logger = require './logger'

class Client
  BASE_URL = "http://www.ctabustracker.com/bustime/api/v1/getpredictions"

  constructor: (options={}) ->
    @apiKey = options.apiKey

  buildQueryString: (busNumber) ->
    params =
      key: @apiKey
      top: 5
      vid: busNumber

    ("#{key}=#{value}" for key, value of params).join("&")

  buildUrl: (busNumber) ->
    "#{BASE_URL}?#{@buildQueryString busNumber}"

  fetch: (options, callback) ->
    options.headers ?= {}
    options.headers['User-Agent'] = "Busted/pre-release"

    requestData =
      options: options
      start: new Date()

    request options, (error, response, body) ->
      logApiRequest requestData, response

      callback body.toString()

  getPredictions: (busNumber, callback) ->
    url = @buildUrl busNumber
    @fetch {url}, callback

module.exports = Client

logApiRequest = (requestData, response) ->
  requestData.end = new Date()
  requestData.duration = requestData.end - requestData.start

  logger.info 'api',
    logType: 'api'
    method: requestData.options.method || 'GET'
    statusCode: response.statusCode
    url: requestData.options.url
    duration: requestData.duration
    options: requestData.options