App.Repo = DS.Model.extend({
	github_id:   DS.attr('number'),
	name:        DS.attr('string'),
	full_name:   DS.attr('string'),
	active:      DS.attr('boolean'),
	description: DS.attr('string'),

	owner: DS.belongsTo('owner'),
});
