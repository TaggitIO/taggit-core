#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require taggit_core

# for more details see: http://emberjs.com/guides/application/
window.App = Em.Application.create
  rootElement: $('#app')

App.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'api'
