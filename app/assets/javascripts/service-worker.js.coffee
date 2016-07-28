log = (args...) ->
  console.log "[Service Worker]", args...

openURL = (clients, url) ->
  clients.matchAll(type: "window").then(focusOrOpenWindow.bind self, url)

focusOrOpenWindow = (url, windowClients) ->
  for client in windowClients
    if client.url is url and "focus" of client
      return client.focus().then (focusedClient) ->
        # Emulate refresh
        focusedClient.navigate(focusedClient.url) if "navigate" of focusedClient

  return clients.openWindow(url) if clients.openWindow


log("Started", self)

self.addEventListener "install", (event) ->
  self.skipWaiting()
  log("Installed", event)


self.addEventListener "activate", (event) ->
  log("Activated", event)


self.addEventListener "push", (event) ->
  log("Push message received", event)

  notification = if event.data
    event_data = event.data.json()
    [event_data.title, body: event_data.body, data: event_data]
  else
    ["Message received", body: "You have a new message", data: { url: "/" }]

  event.waitUntil(self.registration.showNotification notification...)


self.addEventListener "notificationclick", (event) ->
  event.notification.close()

  event.waitUntil(openURL clients, event.notification.data.url)
