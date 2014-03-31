App.UpdateEmailController = Em.Controller.extend
  actions:
    updateEmail: ->
      user = @get("currentUser")

      emailOptOut = $("input[name='email-opt-out']").prop("checked")
      email       = $("input[name='email']").val()

      if emailOptOut
        params = email_opt_out: true
      else
        params = email: email

      user.setProperties(params).then (user) ->
        user.save()
