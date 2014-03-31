App.RecentReleasesController = Em.ArrayController.extend
  # Break release data up into separate arrays for Bootstrap columns
  leftReleases: (->
    arr = @releases.map (item, index) ->
      return item if index % 2 != 0

    return arr.compact()
  ).property("releases.@each")

  rightReleases: (->
    arr = @releases.map (item, index) ->
      return item if index % 2 == 0

    return arr.compact()
  ).property("releases.@each")
