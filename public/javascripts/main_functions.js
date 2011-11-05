var create_animations, create_event, play, start_animation, time_updated;
play = function() {
  var event_list, song_id, text;
  console.log("starting animation");
  text = $("#text").val();
  song_id = $("#echonest-song-id").val();
  console.log("text: " + text);
  console.log("Song ID: " + song_id);
  event_list = create_animations(song_id, text);
  console.log(event_list);
  return start_animation(event_list);
};
create_animations = function(song_id, text) {
  return [create_event(0, "appear", text)];
};
start_animation = function(event_list) {
  var event, _i, _len, _results;
  _results = [];
  for (_i = 0, _len = event_list.length; _i < _len; _i++) {
    event = event_list[_i];
    _results.push({});
  }
  return _results;
};
time_updated = function(time_updated) {};
create_event = function(mtimestamp, manimation, mtext) {
  var event;
  event = {
    timestamp: mtimestamp,
    animation: manimation,
    text: mtext
  };
  return event;
};