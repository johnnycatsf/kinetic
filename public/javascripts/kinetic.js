var appear, getFMAFile, searchSongs;
appear = function(word) {
  return $("#animation").html(word);
};
searchSongs = function(title) {
  return $.ajax({
    type: 'GET',
    url: "http://developer.echonest.com/api/v4/song/search",
    data: {
      api_key: "CJMTSEJKZGMYYF9UI",
      title: title,
      bucket: "id:fma",
      limit: "true"
    },
    success: errorCallback,
    error: errorCallback,
    dataType: "json"
  });
};
getFMAFile = function(fma_song_id) {
  return "http://freemusicarchive.org/services/playlists/embed/track/" + fma_song_id + ".xml";
};