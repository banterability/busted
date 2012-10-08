trimStopName = require("../lib/helpers").trimStopName

describe "Helpers", ->
  describe "#trimStopName", ->
    it "should trim the common street from stop name", ->
      trimStopName("Halsted & Chicago").should.equal "Chicago"

    it "should handle multi-word common streets", ->
      trimStopName("Chicago Avenue & Lake").should.equal "Lake"

    it "should handle non-intersection stop names", ->
      trimStopName("1700 N Halsted").should.equal "1700 N Halsted"

    it "should handle stop names with non-letter characters", ->
      trimStopName("Halsted & Milwaukee/Grand").should.equal "Milwaukee/Grand"
      trimStopName("Halsted & 63rd Street (Green Line)").should.equal "63rd Street (Green Line)"
