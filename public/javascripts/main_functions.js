var create_animation, create_event, play, start_animation;
play = function() {
  var event_list, song_id, text;
  console.log("starting animation");
  text = $("#text").val();
  song_id = $("#echonest-song-id").val();
  console.log("text: " + text);
  console.log("Song ID: " + song_id);
  event_list = create_animation(song_id, text);
  return console.log(event_list);
};
create_animation = function(song_id, text) {
  return [create_event(0, "appear", text)];
};
start_animation = function() {
  return {};
};
create_event = function(mtimestamp, manimation, mtext) {
  var event;
  event = {
    timestamp: mtimestamp,
    animation: manimation,
    text: mtext
  };
  return event;
};