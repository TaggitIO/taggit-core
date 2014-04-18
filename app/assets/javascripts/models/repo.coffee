App.Repo = DS.Model.extend
  githubId:    DS.attr('number')
  name:        DS.attr('string')
  fullName:    DS.attr('string')
  active:      DS.attr('boolean')
  description: DS.attr('string')

  owner: DS.belongsTo('owner')
