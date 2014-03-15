App.CurrentUserController = Em.ObjectController.extend
  isSignedIn: (->
    @get('model') && @get('model').get('isLoaded')
  ).property 'model.isLoaded'
