App.User = DS.Model.extend
  login:       DS.attr("string")
  name:        DS.attr("string")
  email:       DS.attr("string")
  emailOptOut: DS.attr("boolean")
  gravatarId:  DS.attr("string")

  gravatarUrl: (->
    "http://gravatar.com/avatar/#{@get('gravatarId')}"
  ).property("gravatarId")

  showUpdateEmailForm: (->
    !@get("email") and !@get("emailOptOut")
  ).property("email", "emailOptOut")
