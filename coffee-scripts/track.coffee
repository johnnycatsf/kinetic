class Track
  constructor: (@echonest_track_id, @fma_id) ->
    analyzeSong

  ready: (@ready_callback) ->
    
  analyzeSong: ->
    $.ajax
      type: 'GET'
      url: "http://developer.echonest.com/api/v4/track/profile"
      data: 
        api_key: "CJMTSEJKZGMYYF9UI"
        id: @echonest_track_id
        bucket: "audio_summary"
      success: @analyzeSongCallback
      error: @errorCallback
      dataType: "json"

  analyzeSongCallback: (data, textStatus, jqXHR) -> 
    # data is a json object containing the track analyze data
    console.log(data)
    #if data.response.status.message is "Success"
    console.log("Retrieving analysis for "+data.response.track.title)
    console.log("Analysis url is "+ data.response.track.audio_summary.analysis_url)
    analysis_url = data.response.track.audio_summary.analysis_url
    @retrieveAnalysis(analysis_url)

  retrieveAnalysis: (analysis_url) ->
    $.ajax
      type: 'GET'
      url: "/track_analysis"
      data:
        analysis_url: analysis_url
      success: @retrieveAnalysisCallback
      error: @errorCallback
      dataType: "json"
    
  retrieveAnalysisCallback: (data, textStatus, jqXHR) ->
    console.log("RETRIEVE ANALYSIS CALLBACK")
    console.log(data)
    #data is a json object containing detailed track analysis
    @beats = data.beats
    
    # now we have the data, but we also need the song
    setSongURL()

  setSongURL: ->
    $.ajax
      type: 'GET'
      url: "/get_fma_track_url"
      data:
        track_url: "http://freemusicarchive.org/services/playlists/embed/track/" + @fma_id + ".xml"
      success: @setSongURLCallback
      error: @errorCallback
      dataType: "xml"

  setSongURLCallback: (data, textStatus, jqXHR) ->
    console.log(data)
    @song = data.track.download
    # when complete, say i'm ready
    @ready_callback() if @ready_callback?

  errorCallback: (jqXHR) ->
   alert "there was an error"

  getBeats: ->
    actual_beats = []
    for beat in @beats
      if beat.confidence > 0.5
        actual_beats.add(beat.start)
    return actual_beats
