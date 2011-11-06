searchSongs = ->
  mood = $("input:radio[name=mood]:checked").val()
  console.log(mood)
  $.ajax
    type: 'GET'
    url: "http://developer.echonest.com/api/v4/song/search?bucket=id:fma&bucket=tracks"
    data: 
      api_key: "CJMTSEJKZGMYYF9UI"
      mood: mood
      limit: "true"
    success: searchSongsCallback
    error: errorCallback
    dataType: "json"

searchSongsCallback = (data, textStatus, jqXHR) ->
  console.log("SEARCH SONGS CALLBACK")  
  console.log(data)

  # data.response.songs is a list of songs with title, artist_name, id, etc.
  # we'll choose the first one the fits the users requests   
  song = data.response.songs[0]
  fma_id = song.tracks[0].foreign_id
  echonest_track_id = song.tracks[0].id
  
  console.log("SONG: "+song.title + " ARTIST: "+song.artist_name + "TRACK ID: " + echonest_track_id+" FMA ID: "+fma_id)
  $("input:hidden[name=fma-id]").val(fma_id)
  $("input:hidden[name=echonest-track-id]").val(echonest_track_id)

errorCallback = (jqXHR) ->
  console.log("ERROR")
  console.log(jqXHR)
