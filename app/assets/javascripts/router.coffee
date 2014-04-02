# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->
  @resource('repo',  path: '/:login/:repo')
  @resource('user',  path: '/settings')

App.RepoRoute = Em.Route.extend
  model: (params) ->
    @store.find('repo', "#{params.login}/#{params.repo}")

App.IndexRoute = Em.Route.extend
  setupController: ->
    @controllerFor("recentReleases").set("releases", @store.find("release"))
