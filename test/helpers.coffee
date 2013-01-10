helpers = require("../lib/helpers")

describe "Helpers", ->

  describe "#extractBusNumber", ->
    it "should extract the first number from a string", ->
      helpers.extractBusNumber("Bus 1344").should.equal "1344"

  describe "#trimStopName", ->
    it "should trim the common street from stop name", ->
      helpers.trimStopName("Halsted & Chicago").should.equal "Chicago"

    it "should handle multi-word common streets", ->
      helpers.trimStopName("Chicago Avenue & Lake").should.equal "Lake"

    it "should handle non-intersection stop names", ->
      helpers.trimStopName("1700 N Halsted").should.equal "1700 N Halsted"

    it "should handle stop names with non-letter characters", ->
      helpers.trimStopName("Halsted & Milwaukee/Grand").should.equal "Milwaukee/Grand"
      helpers.trimStopName("Halsted & 63rd Street (Green Line)").should.equal "63rd Street (Green Line)"
