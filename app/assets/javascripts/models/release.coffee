App.Release = DS.Model.extend
  html_url:     DS.attr("string")
  tag_name:     DS.attr("string")
  published_at: DS.attr("date")

  repo: DS.belongsTo("repo", embedded: "always")

App.ReleaseSerializer = DS.ActiveModelSerializer.extend(
  DS.EmbeddedRecordsMixin

  attrs:
    repo: embedded: "always"
)
