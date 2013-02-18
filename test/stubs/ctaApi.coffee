nock = require 'nock'

# Recorded January 30, 2013 at 9:43 PM
# with nock.recorder.rec()

module.exports = ->
  nock('http://www.ctabustracker.com:80')
    .get('/bustime/api/v1/getpredictions?vid=6839&top=5&key=FAKE_API_KEY')
    .reply(
      200,
      "<?xml version=\"1.0\"?>\r\n\r\n\t\t<bustime-response>\t\r\n\t\t\t\r\n\t\t\t\t<prd>\r\n\t\t\t\t\t<tmstmp>20130130 21:42</tmstmp>\r\n\t\t\t\t\t<typ>A</typ>\r\n\t\t\t\t\t<stpnm>Halsted &amp; Blackhawk</stpnm>\r\n\t\t\t\t\t<stpid>5779</stpid>\r\n\t\t\t\t\t<vid>6839</vid>\r\n\t\t\t\t\t\r\n\t\t\t\t\t \t\t\t\t\t\r\n\t\t\t\t\t<dstp>319</dstp>\r\n\t\t\t\t\t<rt>8</rt>\r\n\t\t\t\t\t<rtdir>South Bound</rtdir>\r\n\t\t        \t<des>79th</des>\r\n\t\t        \t<prdtm>20130130 21:43</prdtm>\r\n\t\t        \t\r\n\t\t\t\t</prd>\t\t\t\r\n\t\t\t\r\n\t\t\t\t<prd>\r\n\t\t\t\t\t<tmstmp>20130130 21:42</tmstmp>\r\n\t\t\t\t\t<typ>A</typ>\r\n\t\t\t\t\t<stpnm>Halsted &amp; Evergreen</stpnm>\r\n\t\t\t\t\t<stpid>5780</stpid>\r\n\t\t\t\t\t<vid>6839</vid>\r\n\t\t\t\t\t\r\n\t\t\t\t\t \t\t\t\t\t\r\n\t\t\t\t\t<dstp>1101</dstp>\r\n\t\t\t\t\t<rt>8</rt>\r\n\t\t\t\t\t<rtdir>South Bound</rtdir>\r\n\t\t        \t<des>79th</des>\r\n\t\t        \t<prdtm>20130130 21:44</prdtm>\r\n\t\t        \t\r\n\t\t\t\t</prd>\t\t\t\r\n\t\t\t\r\n\t\t\t\t<prd>\r\n\t\t\t\t\t<tmstmp>20130130 21:42</tmstmp>\r\n\t\t\t\t\t<typ>A</typ>\r\n\t\t\t\t\t<stpnm>Halsted &amp; Scott</stpnm>\r\n\t\t\t\t\t<stpid>15408</stpid>\r\n\t\t\t\t\t<vid>6839</vid>\r\n\t\t\t\t\t\r\n\t\t\t\t\t \t\t\t\t\t\r\n\t\t\t\t\t<dstp>1687</dstp>\r\n\t\t\t\t\t<rt>8</rt>\r\n\t\t\t\t\t<rtdir>South Bound</rtdir>\r\n\t\t        \t<des>79th</des>\r\n\t\t        \t<prdtm>20130130 21:44</prdtm>\r\n\t\t        \t\r\n\t\t\t\t</prd>\t\t\t\r\n\t\t\t\r\n\t\t\t\t<prd>\r\n\t\t\t\t\t<tmstmp>20130130 21:42</tmstmp>\r\n\t\t\t\t\t<typ>A</typ>\r\n\t\t\t\t\t<stpnm>Halsted &amp; Division</stpnm>\r\n\t\t\t\t\t<stpid>15273</stpid>\r\n\t\t\t\t\t<vid>6839</vid>\r\n\t\t\t\t\t\r\n\t\t\t\t\t \t\t\t\t\t\r\n\t\t\t\t\t<dstp>2320</dstp>\r\n\t\t\t\t\t<rt>8</rt>\r\n\t\t\t\t\t<rtdir>South Bound</rtdir>\r\n\t\t        \t<des>79th</des>\r\n\t\t        \t<prdtm>20130130 21:45</prdtm>\r\n\t\t        \t\r\n\t\t\t\t</prd>\t\t\t\r\n\t\t\t\r\n\t\t\t\t<prd>\r\n\t\t\t\t\t<tmstmp>20130130 21:42</tmstmp>\r\n\t\t\t\t\t<typ>A</typ>\r\n\t\t\t\t\t<stpnm>Halsted &amp; North Branch</stpnm>\r\n\t\t\t\t\t<stpid>16125</stpid>\r\n\t\t\t\t\t<vid>6839</vid>\r\n\t\t\t\t\t\r\n\t\t\t\t\t \t\t\t\t\t\r\n\t\t\t\t\t<dstp>3943</dstp>\r\n\t\t\t\t\t<rt>8</rt>\r\n\t\t\t\t\t<rtdir>South Bound</rtdir>\r\n\t\t        \t<des>79th</des>\r\n\t\t        \t<prdtm>20130130 21:47</prdtm>\r\n\t\t        \t\r\n\t\t\t\t</prd>\t\t\t\r\n\r\n\t\t</bustime-response>\r\n\r\n\t\t\r\n",
      {
        'set-cookie': ['ARPT=KIRNNRScl-ctabt-2wb002CKYJQ; path=/', 'JSESSIONID=18051C10DC7143F2A75398842EEC3145; Path=/bustime'],
        'server': 'Apache-Coyote/1.1',
        'content-type': 'text/xml',
        'content-length': '1869',
        'date': 'Thu, 31 Jan 2013 03:43:26 GMT'
      }
    )
