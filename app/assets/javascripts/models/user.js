App.User = DS.Model.extend({
	login:        DS.attr('string'),
	name:         DS.attr('string'),
	email:        DS.attr('string'),
	gravatar_id:  DS.attr('string'),

	gravatarUrl:  function() {
		return "http://www.gravatar.com/avatar/" + this.get('gravatar_id');
	}.property('gravatar_id')
});
