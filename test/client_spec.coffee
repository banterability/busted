Client = require "../lib/client"
stubCtaApi = require "./stubs/ctaApi"
bond = require 'bondjs'

describe "Client", ->

  describe "constructor", ->
    it "initializes with passed-in API key", ->
      demoApiKey = "AAABBBCCCDDDEEEFFF"
      client = new Client({apiKey: demoApiKey})
      client.apiKey.should.equal demoApiKey

  describe "getRoutes", ->
    it "fetches the correct URL", (done) ->
      client = new Client({apiKey: 'FAKE_API_KEY'})
      stubFetchAndReturnOptions(client)

      client.getRoutes (fetchOptions) ->
        fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getroutes?key=FAKE_API_KEY"
        done()

    # it "fetches data from the CTA Bus Tracker API", (done) ->

  describe "getRouteDirections", ->
    it "fetches the correct URL", (done) ->
      client = new Client({apiKey: 'FAKE_API_KEY'})
      stubFetchAndReturnOptions(client)

      client.getRouteDirections 8, (fetchOptions) ->
        fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getdirections?rt=8&key=FAKE_API_KEY"
        done()

    # it "fetches data from the CTA Bus Tracker API", (done) ->

  describe "getStops", ->
    it "fetches the correct URL", (done) ->
      client = new Client({apiKey: 'FAKE_API_KEY'})
      stubFetchAndReturnOptions(client)

      client.getStops 8, 'North Bound', (fetchOptions) ->
        fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getstops?rt=8&dir=North Bound&key=FAKE_API_KEY"
        done()

    # it "fetches data from the CTA Bus Tracker API", (done) ->

  describe "getPredictions", ->
    apiStub = client = null

    before ->
      client = new Client({apiKey: 'FAKE_API_KEY'})
      apiStub = stubCtaApi()

    it "fetches the correct URL", (done) ->
      stubFetchAndReturnOptions(client)

      client.getPredictions 3556, (fetchOptions) ->
        fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getpredictions?vid=3556&top=5&key=FAKE_API_KEY"
        done()

    it "fetches data from the CTA Bus Tracker API", (done) ->
      client.getPredictions 6839, (response) ->
        apiStub.done()
        done()

stubFetchAndReturnOptions = (client) ->
  bond(client, 'fetch').to (options, callback) ->
    callback(options)