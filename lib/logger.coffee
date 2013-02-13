class Logger
  info: (msg, meta) ->
    if meta
      if meta?.logType == "web"
        return @emit "[Request] #{meta.remoteAddress} – #{meta.method} #{meta.url} – #{meta.status} #{meta.responseTime}ms "
      if meta?.logType == "api"
        return @emit "[CTA API] #{meta.method} #{meta.url} – #{meta.statusCode} #{meta.duration}ms"
      @emit "[Info] #{msg} – ", meta
    else
      @emit "[Info] #{msg}"

  emit: (args...) ->
    console.log args... unless process.env.NODE_ENV == "test"

module.exports = logger = new Logger
