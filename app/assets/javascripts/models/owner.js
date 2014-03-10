App.Owner = DS.Model.extend({
	login: DS.attr('string'),
	name:  DS.attr('string'),

	repos: DS.hasMany('repo')
});
