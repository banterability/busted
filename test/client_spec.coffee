Client = require "../lib/client"
stubCTA = require "./stubs/ctaApi"

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
      it "fetches data from the correct API endpoint", (done) ->
        api = stubCTA.getRoutes()

        client.getRoutes (response) ->
          api.done()
          done()

    describe "getRouteDirections", ->
      it "fetches data from the correct API endpoint", (done) ->
        api = stubCTA.getRouteDirections()

        client.getRouteDirections 8, (response) ->
          api.done()
          done()

    describe "getStops", ->
      it "fetches data from the correct API endpoint", (done) ->
        api = stubCTA.getStops()

        client.getStops 8, 'North Bound', (response) ->
          api.done()
          done()

    describe "getPredictions", ->
      it "fetches data from the correct API endpoint", (done) ->
        api = stubCTA.getPredictions()

        client.getPredictions 6839, (response) ->
          api.done()
          done()
