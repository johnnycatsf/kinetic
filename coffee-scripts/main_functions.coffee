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

  # Gets called by the music player. The seek time (in ms),
  # specifies how far along the song we need to be.
  seekTo: (@seek_time) ->
    for item in @_event_queue
      if @seek_time - 250 <= item.time <= @seek_time + 250
        item.animation.apply item.element

# method.apply(el$, options)

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
      @.fadeIn('fast').delay(1000).fadeOut()

    bump: (options) ->
      @.fadeIn('fast').delay(1000).fadeOut()

    jump: (options) ->
      @.fadeIn('fast').delay(1000).fadeOut()

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

jQuery ->
  event_queue = new EventQueue TestData.test_string, TestData.timestamps()

  jp$ = $("#jplayer")
  jEvent = $.jPlayer.event

  jp$.jPlayer
    ready: ->
      $(@).jPlayer "setMedia",
        # ogg:"http://upload.wikimedia.org/wikipedia/en/a/ab/Bruno_Mars_-_Just_the_Way_You_Are.ogg"
        # mp3:"http://freemusicarchive.org/music/download/fe424853241ced3a8045f4e1ff3d6c4a3308f602"
        mp3:"http://www.minneapolisfuckingrocks.com/mp3/taylorswift_jumpthenfall1.mp3"
      .jPlayer("play")
    supplied:"mp3"
    swfPath:"/javascripts/Jplayer.swf"

  jp$.bind jEvent.timeupdate, (e) ->
    t = e.jPlayer.status.currentTime * 1000
    console.log "Time update:", t
    event_queue.seekTo t
