App.Router.map(function() {
  this.resource('owner', { path: '/:login' } );
  this.resource('repo',  { path: '/:login/:name' } );
  this.resource('user',  { path: '/settings' } );
});

App.OwnerRoute = Ember.Route.extend({
	model: function(params) {
		return this.store.find('owner', params.login);
	}
});

App.RepoRoute = Ember.Route.extend({
	model: function(params) {
        return this.store.find('repo', params.login + '/' + params.name );
	}
});

App.UserRoute = Ember.Route.extend({
    model: function(params) {
        return this.store.find('user', 'current');
    }
});

App.ApplicationRoute = Ember.Route.extend({
  setupController: function() {
    this.controllerFor('currentUser')
      .set('model', this.store.find('user', 'current'));
  }
});
