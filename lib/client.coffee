request = require 'request'

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

  getPredictions: (busNumber, callback) ->
    url = @buildUrl busNumber
    console.log "API Fetch: ", url
    request {url}, (err, response, body) ->
      callback body.toString()

module.exports = Client