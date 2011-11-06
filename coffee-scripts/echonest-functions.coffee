getFMAFile = (fma_song_id) ->
  "http://freemusicarchive.org/services/playlists/embed/track/" + fma_song_id + ".xml"

analyzeSong = (echonest_song_id) ->
  $.ajax
    type: 'POST'
    url: "http://developer.echonest.com/api/v4/track/analyze"
    data: 
      api_key: "CJMTSEJKZGMYYF9UI"
      id: echonest_song_id
    success: analyzeSongCallback
    error: errorCallback
    dataType: "json"

retrieveAnalysis = (analysis_url) ->
  $.ajax
    type: 'GET'
    url: analysis_url
    success: errorCallback
    dataType: "json"

analyzeSongCallback = (data, textStatus, jqXHR) -> 
  # data is a json object containing the track analyze data
  console.log(data)
  if data.response.status.message is "Success"
    console.log("Retrieving analysis for "+data.response.track.title)
    console.log("Analysis url is "+ data.response.track.audio_summary.analysis_url)
    analysis_url = data.response.track.audio_summary.analysis_url
    retrieveAnalysis(analysis_url)

errorCallback = (jqXHR) ->
  alert "there was an error"

###
{
    "response": {
        "status": {
            "version": "4.2",
            "code": 0,
            "message": "Success"
        },
        "track": {
            "status": "complete",
            "title": "Neverwas Restored (from Neverwas Soundtrack)",
            "artist": "Philip Glass",
            "id": "TRXXHTJ1294CD8F3B3",
            "analyzer_version": "3.01a",
            "release": "The Orange Mountain Music Philip Glass Sampler Vol.I",
            "audio_md5": "c2a69bd9db0b43725e36c0b092330da3",
            "bitrate": 224,
            "samplerate": 44100,
            "audio_summary": {
                "key": 7,
                "analysis_url": "https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=VI8tmWY%2B%2F6eq85H2G7kmb6e4eWI%3D&Expires=1282240751&AWSAccessKeyId=AKIAIAFEHLM3KJ2XMHRA",
                "tempo": 168.46,
                "mode": 1,
                "time_signature": 4,
                "duration": 120.68526,
                "loudness": -19.14,
                "danceability": .7,
                "energy": .9,
            },
            "md5": "b8abf85746ab3416adabca63141d8c2d"
        }
    }
}
###
