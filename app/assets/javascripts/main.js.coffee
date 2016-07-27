if "serviceWorker" of navigator
  navigator.serviceWorker.register("/service-worker.js")
  .then (registration) ->
    console.log(registration)

    registration.pushManager.subscribe(userVisibleOnly: true)
    .then (subscription) ->
      console.log subscription.endpoint

  .catch (err) ->
    console.error(err)
    alert "Unable to register Service Worker"

else
  alert "Sorry, Service Workers are not supported by your browser. Try Chrome instead"
