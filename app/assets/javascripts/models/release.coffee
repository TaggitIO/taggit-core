App.Release = DS.Model.extend
  htmlUrl:     DS.attr("string")
  tagName:     DS.attr("string")
  publishedAt: DS.attr("date")

  repo: DS.belongsTo("repo", embedded: "always")

App.ReleaseSerializer = DS.ActiveModelSerializer.extend(
  DS.EmbeddedRecordsMixin

  attrs:
    repo: embedded: "always"
)
