Client = require "../lib/client"
stubCTA = require "./stubs/ctaApi"
bond = require 'bondjs'

describe "Client", ->

  describe "constructor", ->
    it "initializes with passed-in API key", ->
      demoApiKey = "AAABBBCCCDDDEEEFFF"
      client = new Client({apiKey: demoApiKey})
      client.apiKey.should.equal demoApiKey

  describe "endpoints", ->
    client = null

    beforeEach ->
      client = new Client({apiKey: 'FAKE_API_KEY'})

    describe "getRoutes", ->
      it "fetches the correct URL", (done) ->
        stubFetchAndReturnOptions(client)

        client.getRoutes (fetchOptions) ->
          fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getroutes?key=FAKE_API_KEY"
          done()

      it "fetches data from the CTA Bus Tracker API", (done) ->
        api = stubCTA.getRoutes()

        client.getRoutes (response) ->
          api.done()
          done()

    describe "getRouteDirections", ->
      it "fetches the correct URL", (done) ->
        stubFetchAndReturnOptions(client)

        client.getRouteDirections 8, (fetchOptions) ->
          fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getdirections?rt=8&key=FAKE_API_KEY"
          done()

      it "fetches data from the CTA Bus Tracker API", (done) ->
        api = stubCTA.getRouteDirections()

        client.getRouteDirections 8, (response) ->
          api.done()
          done()

    describe "getStops", ->
      it "fetches the correct URL", (done) ->
        stubFetchAndReturnOptions(client)

        client.getStops 8, 'North Bound', (fetchOptions) ->
          fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getstops?rt=8&dir=North Bound&key=FAKE_API_KEY"
          done()

      it "fetches data from the CTA Bus Tracker API", (done) ->
        api = stubCTA.getStops()

        client.getStops 8, 'North Bound', (response) ->
          api.done()
          done()

    describe "getPredictions", ->
      it "fetches the correct URL", (done) ->
        stubFetchAndReturnOptions(client)

        client.getPredictions 6839, (fetchOptions) ->
          fetchOptions.url.should.equal "http://www.ctabustracker.com/bustime/api/v1/getpredictions?vid=6839&top=5&key=FAKE_API_KEY"
          done()

      it "fetches data from the CTA Bus Tracker API", (done) ->
        api = stubCTA.getPredictions()

        client.getPredictions 6839, (response) ->
          api.done()
          done()

stubFetchAndReturnOptions = (client) ->
  bond(client, 'fetch').to (options, callback) ->
    callback(options)
