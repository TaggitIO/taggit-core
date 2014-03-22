Em.Application.initializer
  name: "currentUser"

  initialize: (container) ->
    store = container.lookup("store:main")
    user = store.find("user", "current")

    container.optionsForType("user", instantiate: false, singleton: true)
    container.register("user:current", user)

Em.Application.initializer
  name:  "injectCurrentUser"
  after: "currentUser"

  initialize: (container) ->
    container.injection("controller", "currentUser", "user:current")
