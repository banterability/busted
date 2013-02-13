class PredictionStub
  constructor: (options={}) ->
    @busNumber = options.busNumber || '1234'
    @prediction =
      predictedFor: if options.minutesFromNow
          new Date() + (options.minutesFromNow * 60 * 1000)
        else
          new Date()
      generatedAt: new Date()
      type: options.type || 'arrival'
      delayed: options.delayed || false
      distanceAway: options.distanceAway || '1000'
      minutes: options.minutesFromNow || 0
    @route =
      number: options.routeNumber || '1'
      direction: options.routeDirection || 'North Bound'
      destination: options.destination
    @stop =
      stopId: options.stopId || '4321'
      stopName: options.stopName || '1700 N Halsted'

module.exports = {PredictionStub}