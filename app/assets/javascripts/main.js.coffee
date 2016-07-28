areNotificationsSupported = ->
  unless "showNotification" of ServiceWorkerRegistration?.prototype
    console.warn("Notifications aren't supported")
    return false

  if Notification?.permission is "denied"
    console.warn("The user has blocked notifications")
    return false

  # Check if push messaging is supported
  unless "PushManager" of window
    console.warn("Push messaging isn't supported")
    return false

  true

processSubscription = (subscription) ->
  enableNotificationBtn()

  if subscription?
    console.log subscription
    enablePush()
    saveSubscription(subscription)

saveSubscription = (subscription) ->
  subscription = subscription.toJSON()
  deviceData =
    endpoint: subscription.endpoint
    p256dh: subscription.keys?.p256dh
    auth: subscription.keys?.auth

  $.ajax
    url: "/devices"
    method: "POST"
    contentType: "application/json"
    dataType: "json"
    data: JSON.stringify(device: deviceData)
  .then(console.log.bind console)
  .then(refreshDeviceList)
  .fail(console.warn.bind console)

deleteSubscription = (subscription) ->
  endpoint = subscription.toJSON().endpoint

  $.ajax
    url: "/devices/#{btoa endpoint}"
    method: "DELETE"
    contentType: "application/json"
    dataType: "json"
  .then(console.log.bind console)
  .then(refreshDeviceList)
  .fail(console.warn.bind console)

enableNotificationBtn = ->
  $(".js-notifications-btn").prop("disabled", false)

enablePush = ->
  $(".js-notifications-btn").text("Disable notifications on this device")
  App.isPushEnabled = true

disablePush = (maintainState = false) ->
  $(".js-notifications-btn").text("Enable notifications on this device")

  unless maintainState
    App.isPushEnabled = false

refreshDeviceList = ->
  $("#devices-iframe").get(0)?.contentDocument?.location?.reload(true)

setupServiceWorker = (registration) ->
  console.log(registration)

  return unless areNotificationsSupported()

  registration.pushManager.getSubscription()
    .then(processSubscription)
    .catch(console.error.bind console, "Error checking subscription")

subscribe = ->
  navigator.serviceWorker.ready.then (serviceWorkerRegistration) ->
    serviceWorkerRegistration.pushManager.subscribe(userVisibleOnly: true)
    .then (subscription) ->
      enableNotificationBtn()
      enablePush()

      saveSubscription(subscription)

    .catch (error) ->
      if Notification?.permission is "denied"
        console.warn("Permission for Notifications was denied")
      else
        console.error("Unable to subscribe to push", error)
        enableNotificationBtn()

unsubscribe = ->
  navigator.serviceWorker.ready.then (serviceWorkerRegistration) ->
    serviceWorkerRegistration.pushManager.getSubscription()
    .then (subscription) ->
      unless subscription?
        disablePush()
        enableNotificationBtn()
        return

      deleteSubscription(subscription)

      subscription.unsubscribe()
      .then ->
        console.log "unsubscribe", subscription
        disablePush()
        enableNotificationBtn()
      .catch (error) ->
        deleteSubscription(subscription)

        console.error("Unable to unsubscribe", error)
        enableNotificationBtn()
        disablePush(true)
    .catch(console.error.bind console, "Unable to find subscription")


App =
  isPushEnabled: false

$ ->
  $(".js-notifications-btn").on "click", (event) ->
    $(event.target).prop("disabled", true)

    if App.isPushEnabled then unsubscribe() else subscribe()


if "serviceWorker" of navigator
  navigator.serviceWorker.register("/service-worker.js")
    .then(setupServiceWorker)
    .catch(console.error.bind console, "Unable to register Service Worker")
else
  alert "Sorry, Service Workers are not supported by your browser. Try Chrome instead"
