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
    multipliers = [.25, .5, 1, 2, 4]
    t = 0
    out = []
    for i in [1..num_beats]
      t += avg_beat * multipliers[Math.floor(Math.random()*5)]
      out.push t
    out

class EventList
  constructor: (@in_string, @beats) ->
    @text_array = in_string.split(" ")

  # Gets called by the music player. The seek time (in ms),
  # specifies how far along the song we need to be.
  seekTo: (@seekTime) ->

class Animator

# method.apply(el$, options)

# Animation.get("name", options) ------- returns callback method
# Pixar, the animation factory. Get it!! hahahahaha.
class Pixar
  @get: (type, options) ->
    self = @
    return (options) ->
      self.preAnimates(@)
      self[type].apply @, options
      self.postAnimate(@)

  @preAnimate: (el$) ->

  @postAnimate: (el$) ->

  @fade: (options) ->
    @.fadeIn().delay(500).fadeOut()

jQuery ->
  jp$ = $("#jplayer")
  jEvent = $.jPlayer.event

  jp$.jPlayer
    ready: ->
      $(@).jPlayer "setMedia",
        # ogg:"http://upload.wikimedia.org/wikipedia/en/a/ab/Bruno_Mars_-_Just_the_Way_You_Are.ogg"
        mp3:"http://freemusicarchive.org/music/download/fe424853241ced3a8045f4e1ff3d6c4a3308f602"
      .jPlayer("play")
    supplied:"mp3"
    swfPath:"/javascripts/Jplayer.swf"

  jp$.bind jEvent.timeupdate, (e) ->
    #console.log "Time update:", e.jPlayer.status.currentTime * 1000
