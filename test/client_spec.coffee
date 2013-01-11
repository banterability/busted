Client = require("../lib/client")

describe "Client", ->

  describe "constructor", ->
    it "initializes with passed-in API key", ->
      demoApiKey = "AAABBBCCCDDDEEEFFF"
      client = new Client({apiKey: demoApiKey})
      client.apiKey.should.equal demoApiKey
