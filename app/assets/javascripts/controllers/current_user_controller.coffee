App.CurrentUserController = Em.ObjectController.extend
  isSignedIn: (->
    @get('currentUser') && @get('currentUser').get('isLoaded')
  ).property 'currentUser.isLoaded'
