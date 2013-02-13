# Request Profiler
# ----------------
# Modified from:
# Connect - profiler
# Copyright(c) 2011 TJ Holowaychuk
# MIT Licensed
#
# Profile the duration of a request.
#
# Typically this middleware should be utilized
# _above_ all others, as it proxies the `res.end()`
# method, being first allows it to encapsulate all
# other middleware.
#
# ---
#
# This module was designed for stdout, but I reworked it as an event emitter.
# When using the middleware, a profiler instance will emit a `profile` event
# with an object of data about the profile.
#

# Event Emitter
events = require 'events'
# Object merging
{extend} = require 'underscore'

class Profiler extends events.EventEmitter
  compare: (start, end) ->
    diff =
      responseTime: end.time-start.time
      memoryRSS: formatBytes(end.mem.rss - start.mem.rss)
      heapBefore:formatBytes(start.mem.heapUsed) + " / " + formatBytes(start.mem.heapTotal)
      heapAfter: formatBytes(end.mem.heapUsed) + " / " + formatBytes(end.mem.heapTotal)

  snapshot: () =>
    mem: process.memoryUsage()
    time: new Date

  middleware: (req, res, next) =>
    # Start the profile
    start = @snapshot()

    # Save a reference to the original `end` so it can be called later
    end = res.end

    # Redefine the `end` callback to take the closing snapshot of the profile.
    res.end = (data, encoding) =>
      # Reassign the old `end` and call it
      res.end = end
      res.end data, encoding

      # Take end snapshot and return a profile of the request
      profile = @compare start, @snapshot()

      # Emit a 'profile' event
      @emit 'profile', profile, req, res

    next()

# Public interface is a factory method
module.exports = () -> new Profiler

## Private Helpers
formatBytes = (bytes) ->
  kb = 1024
  mb = 1024 * kb
  gb = 1024 * mb
  return bytes + "b"  if bytes < kb
  return (bytes / kb).toFixed(2) + "kb"  if bytes < mb
  return (bytes / mb).toFixed(2) + "mb"  if bytes < gb
  (bytes / gb).toFixed(2) + "gb"
