//= require jquery
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require taggit_core

App = Em.Application.create({
    rootElement: $('#app')
});

App.ApplicationAdapter = DS.RESTAdapter.extend({
	// host:      'http://localhost:8080',
	namespace: 'api'
});
