Presenters = require "../lib/presenters"
helpers = require "./helpers"

describe "Presenters", ->

  before ->
    @prediction1 = new helpers.PredictionStub stopName: "Michigan & 29th Street"
    @prediction2 = new helpers.PredictionStub {stopName: "Michigan & 28th Street", minutesFromNow: 1}
    @allPredictions = [@prediction1, @prediction2]

  describe "WebPresenter", ->
    beforeEach ->
      @presenter = new Presenters.WebPresenter(@allPredictions)

    describe "formatPredictions", ->
      it "returns an object with values for the given prediction data", ->
        @presenter.formatPrediction(@prediction2).should.eql
          stopName: '28th Street'
          estimate: 1
          percentComplete: 90

    describe "generateTitle", ->
      it "returns an object with route data", ->
        @presenter.generateTitle().should.eql
          routeNumber: '1'
          routeDirection: 'North Bound'
          busNumber: '1234'

    # describe "generateBody", ->

    # describe "respond", ->

  describe "SMSPresenter", ->
    beforeEach ->
      @presenter = new Presenters.SMSPresenter(@allPredictions)

    describe "formatPredictions", ->
      it "returns a string for the given prediction", ->
        @presenter.formatPrediction(@prediction2).should.equal "In 1m: 28th Street"

    describe "generateTitle", ->
      it "returns a string with route data", ->
        @presenter.generateTitle().should.equal "Rt 1:"

    # describe "generateBody", ->

    # describe "respond", ->
