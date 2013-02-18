request = require 'request'
logger = require './logger'

class Client
  BASE_URL = "http://www.ctabustracker.com/bustime/api/v1"

  constructor: (options={}) ->
    @apiKey = options.apiKey

  buildQueryString: (params) ->
    params.key = @apiKey
    ("#{key}=#{value}" for key, value of params).join("&")

  buildUrl: (endpoint, params={}) ->
    queryString = @buildQueryString params
    "#{BASE_URL}/#{endpoint}?#{queryString}"

  fetch: (options, callback) ->
    options.headers ?= {}
    options.headers['User-Agent'] = "Busted/pre-release"

    requestData =
      options: options
      start: new Date()

    request options, (error, response, body) ->
      logApiRequest requestData, response
      callback body.toString()

  ## routes ##

  getRoutes: (callback) ->
    url = @buildUrl 'getroutes'
    @fetch {url}, callback

  getRouteDirections: (route, callback) ->
    url = @buildUrl 'getdirections', {rt: route}
    @fetch {url}, callback

  getStops: (route, direction, callback) ->
    url = @buildUrl 'getstops', {rt: route, dir: direction}
    @fetch {url}, callback

  getPredictions: (busNumber, callback) ->
    url = @buildUrl 'getpredictions', {vid: busNumber, top: 5}
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