play = () ->
  console.log("starting animation")
  text = $("#text").val()
  song_id = $("#echonest-song-id").val()
  console.log("text: "+text)
  console.log("Song ID: "+song_id)
  event_list = create_animations(song_id, text)
  console.log(event_list)
  start_animation(event_list)

create_animations = (song_id, text) ->
  # Creates a list of events in increasing temporal order
  # Each event contains a word and an animation associated with a timestamp
  return [create_event(0, "appear", text)]

start_animation = (event_list) ->
  # initialize JPlayer
  # TODO: setup callback functions for beats
  # loop goes hur

  for event in event_list
    {}
  
  # start music

  # 

time_updated = (time_updated) ->
  

create_event = (mtimestamp, manimation, mtext) ->
  event =
    timestamp: mtimestamp
    animation: manimation
    text: mtext
  return event
