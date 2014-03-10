App.CurrentUserController = Ember.ObjectController.extend({
  isSignedIn: function() {
    return this.get('model') && this.get('model').get('isLoaded');
  }.property('model.isLoaded')
});
