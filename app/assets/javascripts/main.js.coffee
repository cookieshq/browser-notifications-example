logToConsoleAndScreen = (level, message, args...) ->
  console[level](message, args...)

  $ ->
    $container = $("#errors-container").empty()
    $("<div/>").addClass("message is-#{level}").text(message).prependTo($container)

logger =
  warn:  logToConsoleAndScreen.bind(window, "warn")
  error: logToConsoleAndScreen.bind(window, "error")

areNotificationsSupported = ->
  unless ServiceWorkerRegistration and "showNotification" of ServiceWorkerRegistration.prototype
    logger.warn("Notifications aren't supported")
    return false

  if Notification?.permission is "denied"
    logger.warn("Notifications are blocked on this device")
    return false

  # Check if push messaging is supported
  unless "PushManager" of window
    logger.warn("Push messaging isn't supported")
    return false

  true

processSubscription = (subscription) ->
  enableNotificationBtn()

  if subscription?
    console.log "Existing subscription found", subscription
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
  .then(console.log.bind console, "Subscription saved")
  .then(refreshDeviceList)
  .fail(logger.warn.bind window, "Error saving subscription")

deleteSubscription = (subscription) ->
  endpoint = subscription.toJSON().endpoint

  $.ajax
    url: "/devices/#{btoa endpoint}"
    method: "DELETE"
    contentType: "application/json"
    dataType: "json"
  .then(console.log.bind console, "Subscription deleted")
  .then(refreshDeviceList)
  .fail(logger.warn.bind window, "Error deleting subscription")

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
  console.log("Service worker registered", registration)

  return unless areNotificationsSupported()

  registration.pushManager.getSubscription()
    .then(processSubscription)
    .catch(logger.error.bind window, "Error checking subscription")

subscribe = ->
  navigator.serviceWorker.ready.then (serviceWorkerRegistration) ->
    serviceWorkerRegistration.pushManager.subscribe(userVisibleOnly: true)
    .then (subscription) ->
      enableNotificationBtn()
      enablePush()

      saveSubscription(subscription)

    .catch (error) ->
      if Notification?.permission is "denied"
        logger.warn("Permission for Notifications was denied")
      else
        logger.error("Unable to subscribe to push", error)
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
        console.log "Unsubscribed from notifications", subscription
        disablePush()
        enableNotificationBtn()
      .catch (error) ->
        deleteSubscription(subscription)

        logger.error("Unable to unsubscribe", error)
        enableNotificationBtn()
        disablePush(true)
    .catch(logger.error.bind window, "Unable to find subscription")


App =
  isPushEnabled: false

$ ->
  $(".js-notifications-btn").on "click", (event) ->
    $(event.target).prop("disabled", true)

    if App.isPushEnabled then unsubscribe() else subscribe()


if "serviceWorker" of navigator
  navigator.serviceWorker.register("/service-worker.js")
    .then(setupServiceWorker)
    .catch(logger.error.bind window, "Unable to register Service Worker")
else
  logger.warn "Sorry, Service Workers are not supported by your browser. Try Chrome instead"
