class Logger
  info: (msg, meta) ->
    if meta
      if meta?.logType == "web"
        return console.log "[Request] #{meta.remoteAddress} – #{meta.method} #{meta.url} – #{meta.status} #{meta.responseTime}ms "
      if meta?.logType == "api"
        return console.log "[CTA API] #{meta.method} #{meta.url} – #{meta.statusCode} #{meta.duration}ms"
      console.log "[Info] #{msg}", meta
    else
      console.log "[Info] #{msg}"

module.exports = logger = new Logger
