Presenters = require("../lib/presenters")

PREDICTION_STUB = [
  {
    busNumber: '6418'
    prediction:
      predictedFor: new Date()
      generatedAt:  new Date()
      type: 'arrival'
      delayed: false
      distanceAway: '378'
      minutes: 0
    route:
      number: '4'
      direction: 'North Bound'
      destination: undefined
    stop:
      stopId: '1565'
      stopName: 'Michigan & 29th Street'
  }, {
    busNumber: '6418'
    prediction:
      predictedFor: new Date()
      generatedAt:  new Date() + 1000 * 60
      type: 'arrival'
      delayed: false
      distanceAway: '1032'
      minutes: 1
    route:
      number: '4'
      direction: 'North Bound'
      destination: undefined
    stop:
      stopId: '1566'
      stopName: 'Michigan & 28th Street'
  }
]

describe "Presenters", ->

  describe "WebPresenter", ->
    beforeEach ->
      @presenter = new Presenters.WebPresenter(PREDICTION_STUB)

    # describe "formatPredictions", ->

    describe "generateTitle", ->
      it "returns an object with route data", ->
        @presenter.generateTitle().should.eql
          routeNumber: '4'
          routeDirection: 'North Bound'
          busNumber: '6418'

    # describe "generateBody", ->

    # describe "respond", ->

  describe "SMSPresenter", ->
    beforeEach ->
      @presenter = new Presenters.SMSPresenter(PREDICTION_STUB)

    # describe "formatPredictions", ->

    describe "generateTitle", ->
      it "returns an object with route data", ->
        @presenter.generateTitle().should.equal "Rt 4:"

    # describe "generateBody", ->

    # describe "respond", ->
