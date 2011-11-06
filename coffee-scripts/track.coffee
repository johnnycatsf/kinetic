class Track
  constructor: (@echonest_track_id) ->
    @analyzeSong()

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

  analyzeSongCallback: (data, textStatus, jqXHR) => 
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

  retrieveAnalysisCallback: (data, textStatus, jqXHR) =>
    console.log("RETRIEVE ANALYSIS CALLBACK")
    console.log(data)
    #data is a json object containing detailed track analysis
    @beats = data.beats
    @song_end = data.track.duration * 1000
    # when complete, say i'm ready
    @ready_callback() if @ready_callback?

  errorCallback: (jqXHR, textstatus, error_thrown) ->
   console.error "there was an error", jqXHR, textstatus, error_thrown

  getSongEnd: -> @song_end

  getBeats: ->
    actual_beats = []
    for beat in @beats
      if beat.confidence > 0.5
        actual_beats.push(beat.start * 1000)
    return actual_beats
