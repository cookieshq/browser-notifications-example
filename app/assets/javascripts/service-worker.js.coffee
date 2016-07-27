console.log("Started", self)

self.addEventListener "install", (event) ->
  self.skipWaiting()
  console.log("Installed", event)

self.addEventListener "activate", (event) ->
  console.log("Activated", event)

self.addEventListener "push", (event) ->
  console.log("Push message received", event)

