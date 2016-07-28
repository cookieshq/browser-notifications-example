log = (args...) ->
  console.log "[Service Worker]", args...

log("Started", self)

self.addEventListener "install", (event) ->
  self.skipWaiting()
  log("Installed", event)


self.addEventListener "activate", (event) ->
  log("Activated", event)


self.addEventListener "push", (event) ->
  log("Push message received", event)

