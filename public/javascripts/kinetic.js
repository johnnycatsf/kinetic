var EventQueue, Pixar, Routine, TestData, appear, searchSongs;
TestData = (function() {
  function TestData() {}
  TestData.test_string = "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.  Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this.  But, in a larger sense, we can not dedicate -- we can not consecrate -- we can not hallow -- this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion -- that we here highly resolve that these dead shall not have died in vain -- that this nation, under God, shall have a new birth of freedom -- and that government of the people, by the people, for the people, shall not perish from the earth.";
  TestData.timestamps = function() {
    var avg_beat, i, multipliers, num_beats, out, t;
    avg_beat = 500;
    num_beats = 100;
    multipliers = [.5, 1, 2];
    t = 0;
    out = [];
    for (i = 1; 1 <= num_beats ? i <= num_beats : i >= num_beats; 1 <= num_beats ? i++ : i--) {
      t += avg_beat * multipliers[Math.floor(Math.random() * multipliers.length)];
      out.push(t);
    }
    return out;
  };
  return TestData;
})();
EventQueue = (function() {
  function EventQueue(in_string, beats, song_length) {
    this.in_string = in_string;
    this.beats = beats;
    this.song_length = song_length;
    this._event_queue = [];
    this.text_array = in_string.split(" ");
    this._linkBeats();
  }
  EventQueue.prototype._linkBeats = function() {
    var el$, index, t, _len, _ref, _results;
    _ref = this.beats;
    _results = [];
    for (index = 0, _len = _ref.length; index < _len; index++) {
      t = _ref[index];
      if (index >= this.text_array.length) {
        break;
      }
      el$ = $("<div>" + this.text_array[index] + "</div>");
      _results.push(this._event_queue.push({
        time: t,
        animation: Pixar.getRandom(),
        element: el$
      }));
    }
    return _results;
  };
  EventQueue.prototype.getNextBeat = function() {
    var beat, _i, _len, _ref;
    _ref = this.beats;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      beat = _ref[_i];
      if (beat > this.seek_time) {
        return beat;
      }
    }
    return this.song_length;
  };
  EventQueue.prototype.seekTo = function(seek_time) {
    var item, _i, _len, _ref, _ref2, _results;
    this.seek_time = seek_time;
    _ref = this._event_queue;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      _results.push((this.seek_time - 250 <= (_ref2 = item.time) && _ref2 <= this.seek_time + 250) ? item.animation.apply(item.element) : void 0);
    }
    return _results;
  };
  return EventQueue;
})();
Pixar = (function() {
  function Pixar() {}
  Pixar.get = function(type, options) {
    var self;
    self = this;
    return function(options) {
      self.preAnimate(this);
      self.animations[type].apply(this, options);
      return self.postAnimate(this);
    };
  };
  Pixar.getRandom = function() {
    var self;
    self = this;
    return function(options) {
      var animation, name, names, rand_name, _ref;
      names = [];
      _ref = self.animations;
      for (name in _ref) {
        animation = _ref[name];
        names.push(name);
      }
      rand_name = names[Math.floor(Math.random() * names.length)];
      self.preAnimate(this);
      self.animations[rand_name].apply(this, options);
      return self.postAnimate(this);
    };
  };
  Pixar.preAnimate = function(el$) {
    return $("#animation").append(el$);
  };
  Pixar.postAnimate = function(el$) {};
  Pixar.animations = {
    fade: function(options) {
      return this.show().delay(1000).fadeOut();
    },
    bump: function(options) {
      return this.show().delay(1000).fadeOut();
    },
    jump: function(options) {
      return this.show().delay(1000).fadeOut();
    }
  };
  return Pixar;
})();
Routine = (function() {
  function Routine(desired_duration, el$, event_queue) {
    this.desired_duration = desired_duration;
    this.el$ = el$;
    this.event_queue = event_queue;
  }
  Routine.prototype.start = function(start_time) {
    var animation, next_beat, time_till_next;
    next_beat = this.event_queue.getNextBeat();
    time_till_next = next_beat - start_time;
    if (next_beat >= start_time + this.desired_duration) {
      animation = Pixar.get(time_till_next, "exit");
      return animation.apply(this.el$);
    } else {
      animation = Pixar.get(time_till_next);
      return animation.apply(this.el$, this.start(start_time));
    }
  };
  return Routine;
})();
jQuery(function() {
  var jEvent, jp$, track, trackReady;
  jp$ = $("#jplayer");
  jEvent = $.jPlayer.event;
  track = new Track("TRQUWYF131BAB75456", 24209);
  trackReady = function() {
    var event_queue, track_url;
    event_queue = new EventQueue(TestData.test_string, track.getBeats(), track.getSongEnd());
    console.log("Setup error queue", event_queue);
    track_url = track.getTrackUrl();
    console.log(track_url);
    console.log("Setting up jPlayer with music!");
    jp$.jPlayer({
      ready: function() {
        console.log("Ready! Attaching media");
        return $(this).jPlayer("setMedia", {
          mp3: track_url
        }).jPlayer("play");
      },
      supplied: "mp3",
      swfPath: "/javascripts/Jplayer.swf"
    });
    return jp$.bind(jEvent.timeupdate, function(e) {
      var t;
      t = e.jPlayer.status.currentTime * 1000;
      console.log("Time update:", t);
      return event_queue.seekTo(t);
    });
  };
  return track.ready(trackReady);
});
appear = function(word) {
  return $("#animation").html(word);
};
searchSongs = function(mood) {
  return $.ajax({
    type: 'GET',
    url: "http://developer.echonest.com/api/v4/song/search",
    data: {
      api_key: "CJMTSEJKZGMYYF9UI",
      mood: "sad",
      bucket: "id:fma",
      limit: "true"
    },
    success: errorCallback,
    error: errorCallback,
    dataType: "json"
  });
};