searchSongs = (title) ->
  $.ajax
    type: 'GET'
    url: "http://developer.echonest.com/api/v4/song/search"
    data: 
      api_key: "CJMTSEJKZGMYYF9UI"
      title: title
      bucket: "id:fma"
      limit: "true"
    success: errorCallback
    error: errorCallback
    dataType: "json"

getFMAFile = (fma_song_id) ->
  "http://freemusicarchive.org/services/playlists/embed/track/" + fma_song_id + ".xml"
