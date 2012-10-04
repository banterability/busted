fetch = require 'fetch'

BASE_URL = "http://www.ctabustracker.com/bustime/api/v1/getpredictions"

module.exports.fetchPredictions = (busNumber, apiKey, callback) ->
  url = buildUrl(busNumber, apiKey)
  console.log "API Fetch: ", url
  fetch.fetchUrl url, (err, meta, body) ->
    callback body.toString()

buildQueryString = (busNumber, apiKey) ->
  params =
    key: apiKey
    top: 5
    vid: busNumber

  ("#{key}=#{value}" for key, value of params).join("&")

buildUrl = (busNumber, apiKey) ->
  "#{BASE_URL}?#{buildQueryString busNumber, apiKey}"
