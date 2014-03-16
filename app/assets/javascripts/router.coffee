# For more information see: http://emberjs.com/guides/routing/

App.Router.map ()->
  # @resource('posts')
  @resource('owner', path: '/:login')
  @resource('repo',  path: '/:login/:repo')
  @resource('user',  path: '/settings')

App.OwnerRoute = Em.Route.extend
  model: (params) ->
    @store.find('owner', params.login)

App.RepoRoute = Em.Route.extend
  model: (params) ->
    @store.find('repo', "#{params.login}/#{params.repo}")

App.UserRoute = Em.Route.extend
  model: (params) ->
    @store.find('user', 'current')

App.ApplicationRoute = Em.Route.extend
  setupController: ->
    @controllerFor('currentUser')
      .set('model', @store.find('user', 'current'))
