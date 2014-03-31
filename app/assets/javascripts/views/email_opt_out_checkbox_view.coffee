App.EmailOptOutCheckboxView = Em.Checkbox.extend
  click: (event) ->
    checked = event.target.checked
    $("#email").prop("disabled", checked)
