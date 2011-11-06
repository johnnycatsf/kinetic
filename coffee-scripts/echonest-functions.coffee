searchSongs = (mood) ->
  $.ajax
    type: 'GET'
    url: "http://developer.echonest.com/api/v4/song/search"
    data: 
      api_key: "CJMTSEJKZGMYYF9UI"
      mood: "sad"
      bucket: "id:fma"
      limit: "true"
    success: errorCallback
    error: errorCallback
    dataType: "json"
