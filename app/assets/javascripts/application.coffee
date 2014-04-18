#= require jquery
#= require jquery-ujs
#= require handlebars
#= require ember
#= require ember-data
#= require underscore
#= require_self
#= require taggit_core

# for more details see: http://emberjs.com/guides/application/
window.App = Em.Application.create
  rootElement: $('#app')

App.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api'
