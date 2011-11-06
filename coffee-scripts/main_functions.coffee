# play = () ->
#   console.log("starting animation")
#   text = $("#text").val()
#   song_id = $("#echonest-song-id").val()
#   console.log("text: "+text)
#   console.log("Song ID: "+song_id)
#   event_list = create_animations(song_id, text)
#   console.log(event_list)
#   start_animation(event_list)
# 
# create_animations = (song_id, text) ->
#   # Creates a list of events in increasing temporal order
#   # Each event contains a word and an animation associated with a timestamp
#   return [create_event(0, "appear", text)]
# 
# start_animation = (event_list) ->
#   # TODO: setup callback functions for beats
#   # loop goes hur
# 
#   for event in event_list
#     {}
#   
#   # start music
# 
#   # 
# 
# time_updated = (time_updated) ->
#   
# 
# create_event = (mtimestamp, manimation, mtext) ->
#   event =
#     timestamp: mtimestamp
#     animation: manimation
#     text: mtext
#   return event

# Procedure
# 1. Assume we have an array of timestamps from the song that represent
#    beat impulses.
# 2. We have a list of word (phrases) that we need to sync to those beats.
# 3. We need to decide which words to play on which beats.
  #   one word per <N> beats where <N> is some arbitrary constant
# 4. We need to decide which animations to tie to which words.
  #   Random for now
# 4. On each beat, a word plays some interesting and artistic animation.
  #   Create an element for each word. Append it to the page and apply
  #   the callback anmiation method

class TestData
  @test_string: "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.

  Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this.

  But, in a larger sense, we can not dedicate -- we can not consecrate -- we can not hallow -- this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion -- that we here highly resolve that these dead shall not have died in vain -- that this nation, under God, shall have a new birth of freedom -- and that government of the people, by the people, for the people, shall not perish from the earth."

  @timestamps: ->
    avg_beat = 500
    num_beats = 100
    multipliers = [.5, 1, 2]
    t = 0
    out = []
    for i in [1..num_beats]
      t += avg_beat * multipliers[Math.floor(Math.random()*multipliers.length)]
      out.push t
    out

class EventQueue
  constructor: (@in_string, @beats, @song_length) ->
    @_event_queue = []

    # Rate (in ms) our clock checks for animation keyframes
    @rate = 15

    @text_array = in_string.split(" ")
    @_linkBeats()

  _linkBeats: ->
    for t,index in @beats
      # FIXME need to check not overflowing index
      if index >= @text_array.length then break
      el$ = $("<div>#{@text_array[index]}</div>")
      @_event_queue.push
        time: t
        animation: Pixar.getRandom()
        element: el$

  getNextBeat: ->
    for beat in @beats
      if beat > @seek_time then return beat

    return @song_length

  stop: (e) =>
    console.log e, e.jPlayer.status
    console.log "STOPPING"
    @playing = false
    clearTimeout @timeout

  start: (e) =>
    console.log "STARTING"
    @playing = true

  # Gets called by the music player. The seek time (in ms),
  # specifies how far along the song we need to be.
  seekTo: (@seek_time) ->
    if @playing isnt true then return

    console.log "SEEKING TO: #{@seek_time}"

    if @timeout?
      console.log "CLEARING TIMEOUT: #{@timeout}"
      clearTimeout @timeout

    @_runEventQueue(@seek_time)

  _runEventQueue: (start_time) ->
    console.log "Frame: #{start_time}"
    if @seek_time > start_time then return

    for item in @_event_queue
      if start_time - @rate <= item.time <= start_time + @rate
        item.animation.apply item.element
        console.log "Playing: '#{item.element}'"

    next_start_time = start_time + @rate

    @timeout = setTimeout =>
      @_runEventQueue next_start_time
    , @rate

# Animation.get("name", options) ------- returns callback method
# Pixar, the animation factory. Get it!! hahahahaha.
class Pixar
  @get: (type, options) ->
    self = @
    return (options) ->
      self.preAnimate(@)
      self.animations[type].apply @, options
      self.postAnimate(@)

  @getRandom: ->
    self = @
    return (options) ->
      names = []
      for name, animation of self.animations
        names.push name

      rand_name = names[Math.floor(Math.random()*names.length)]

      self.preAnimate(@)
      self.animations[rand_name].apply @, options
      self.postAnimate(@)

  @preAnimate: (el$) ->
    $("#animation").append el$

  @postAnimate: (el$) ->

  # Beat length
    # Each animation till next beat
  # Routine
    # fade
    # bounce
    # pump
    # swipe
    # pump
    # pump
    # out
    #
  # Input is total amount of routine time
  # Each animation gets passed in total amount of time.

  @animations =
    fade: (options) ->
      @.show().delay(1000).fadeOut()

    bump: (options) ->
      @.show().delay(1000).fadeOut()

    jump: (options) ->
      @.show().delay(1000).fadeOut()

class Routine
  constructor: (@desired_duration, @el$, @event_queue) ->

  #FIXME Catch end of song case

  # start should always be called on a beat
  start: (start_time) ->
    # next_beat is absolute time
    next_beat = @event_queue.getNextBeat()
    time_till_next = next_beat - start_time

    if next_beat >= start_time + @desired_duration
      animation = Pixar.get(time_till_next, "exit")
      animation.apply @el$
    else
      animation = Pixar.get(time_till_next)
      animation.apply @el$, @start(start_time)

    # Get animation
    # Set animation params to last for rel_time
    # Call animation
    #
    # When animation is done, grab the next beat
    # See if next beat is past desired_time
    # if so, take up remaining slack with an exit-type animation
    # if not, load up a new animation of appropriate time class

class SongSearch
  @searchSongs: =>
    console.log "Searching for a song!"
    mood = $("input:radio[name=mood]:checked").val()
    console.log(mood)
    $.ajax
      type: 'GET'
      url: "http://developer.echonest.com/api/v4/song/search?bucket=id:fma&bucket=tracks"
      data: 
        api_key: "CJMTSEJKZGMYYF9UI"
        mood: mood
        limit: "true"
      success: SongSearch.searchSongsCallback
      error: SongSearch.errorCallback
      dataType: "json"

  @searchSongsCallback: (data, textStatus, jqXHR) =>
    console.log("SEARCH SONGS CALLBACK")  
    console.log(data)

    # data.response.songs is a list of songs with title, artist_name, id, etc.
    # we'll choose the first one the fits the users requests   
    song = data.response.songs[0]
    fma_str = song.tracks[0].foreign_id
    fma_arr = fma_str.split(":")
    fma_id = fma_arr[fma_arr.length-1]
    echonest_track_id = song.tracks[0].id

    console.log("SONG: "+song.title + " ARTIST: "+song.artist_name + "TRACK ID: " + echonest_track_id+" FMA ID: "+fma_id)
    $("input:hidden[name=fma-id]").val(fma_id)
    $("input:hidden[name=echonest-track-id]").val(echonest_track_id)

    window.track = new Track echonest_track_id, fma_id
    window.track.ready window.trackReady

  @errorCallback: (jqXHR) =>
    console.log("ERROR")
    console.log(jqXHR)

jQuery ->
  jp$ = $("#jplayer")
  jEvent = $.jPlayer.event

  $("#play_song").click SongSearch.searchSongs

  # track = new Track "TRBOFQJ131BAB774CC", 34681

  window.trackReady = ->
    track = window.track
    event_queue = new EventQueue TestData.test_string, 
                                 track.getBeats(),
                                 track.getSongEnd()

    console.log "Setup queue", event_queue

    track_url = track.getTrackUrl()
    console.log track_url

    console.log "Setting up jPlayer with music!"
    jp$.jPlayer
      ready: ->
        console.log "Ready! Attaching media"
        $(@).jPlayer "setMedia",
          # ogg:"http://upload.wikimedia.org/wikipedia/en/a/ab/Bruno_Mars_-_Just_the_Way_You_Are.ogg"
          # mp3:"http://freemusicarchive.org/music/download/fe424853241ced3a8045f4e1ff3d6c4a3308f602"
          # mp3:"http://www.minneapolisfuckingrocks.com/mp3/taylorswift_jumpthenfall1.mp3"
          # mp3:"http://freemusicarchive.org/music/download/b5159a74e2968626d394bacba885d57bd2749d2d"
          mp3:track_url
        .jPlayer("play")
      supplied:"mp3"
      swfPath:"/javascripts/Jplayer.swf"

    jp$.bind jEvent.timeupdate, (e) ->
      t = e.jPlayer.status.currentTime * 1000
      console.log "Time update:", t
      event_queue.seekTo t

    jp$.bind jEvent.abort, event_queue.stop
    jp$.bind jEvent.pause, event_queue.stop
    jp$.bind jEvent.ended, event_queue.stop

    jp$.bind jEvent.play, event_queue.start
