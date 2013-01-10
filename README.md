# Busted [![Build Status](https://travis-ci.org/banterability/busted.png?branch=master)](https://travis-ci.org/banterability/busted)

Next stop information for Chicago busses via SMS & Web

## Configuration

Expects the following environment variables:

- `CTA_API_KEY`: To retrieve prediction data. Key available from [CTA Bus Tracker](http://www.transitchicago.com/developers/bustracker.aspx)
- `NODEFLY_API_KEY`: Monitoring & performance analysis. Key available from [Nodefly](http://apm.nodefly.com/)

## Usage

### SMS

Text '1366':

```
Rt 8:
In 1m: Milwaukee/Grand (Blue Line)
In 1m: Erie
In 2m: Huron
In 3m: Chicago
In 4m: North Branch
```

### Web

```
/route/1366
```

# License

MIT
