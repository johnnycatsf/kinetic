play = () ->
    console.log("starting animation")
    text = $("#text").val()
    song_id = $("#echonest-song-id").val()
    console.log("text: "+text)
    console.log("Song ID: "+song_id)
    event_list = create_animation(song_id, text)
    console.log(event_list)

create_animation = (song_id, text) ->
    return [create_event(0, "appear", text)]

start_animation = () -> {}

create_event = (mtimestamp, manimation, mtext) ->
    event =
        timestamp: mtimestamp
        animation: manimation
        text: mtext
    return event