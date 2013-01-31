Client = require "../lib/client"
stubCtaApi = require "./stubs/ctaApi"

describe "Client", ->

  describe "constructor", ->
    it "initializes with passed-in API key", ->
      demoApiKey = "AAABBBCCCDDDEEEFFF"
      client = new Client({apiKey: demoApiKey})
      client.apiKey.should.equal demoApiKey

  describe "getPredictions", ->
    apiStub = null

    beforeEach ->
      apiStub = stubCtaApi()

    it "fetches data from the CTA Bus Tracker API", (done) ->
      client = new Client({apiKey: "FAKE_API_KEY"})
      client.getPredictions 6839, (response) ->
        apiStub.done()
        done()
