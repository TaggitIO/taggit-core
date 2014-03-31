App.User = DS.Model.extend
  login:         DS.attr("string")
  name:          DS.attr("string")
  email:         DS.attr("string")
  email_opt_out: DS.attr("boolean")
  gravatar_id:   DS.attr("string")

  gravatarUrl: (->
    "http://gravatar.com/avatar/#{@get('gravatar_id')}"
  ).property("gravatar_id")

  showUpdateEmailForm: (->
    !@get("email") and !@get("email_opt_out")
  ).property("email", "email_opt_out")
