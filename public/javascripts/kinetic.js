var EventQueue, Pixar, Routine, TestData, Track, appear, errorCallback, searchSongs, searchSongsCallback;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Track = (function() {
  function Track(echonest_track_id, fma_id) {
    this.echonest_track_id = echonest_track_id;
    this.fma_id = fma_id;
    this.setSongURLCallback = __bind(this.setSongURLCallback, this);
    this.retrieveAnalysisCallback = __bind(this.retrieveAnalysisCallback, this);
    this.analyzeSongCallback = __bind(this.analyzeSongCallback, this);
    this.analyzeSong();
  }
  Track.prototype.ready = function(ready_callback) {
    this.ready_callback = ready_callback;
  };
  Track.prototype.analyzeSong = function() {
    return $.ajax({
      type: 'GET',
      url: "http://developer.echonest.com/api/v4/track/profile",
      data: {
        api_key: "CJMTSEJKZGMYYF9UI",
        id: this.echonest_track_id,
        bucket: "audio_summary"
      },
      success: this.analyzeSongCallback,
      error: this.errorCallback,
      dataType: "json"
    });
  };
  Track.prototype.analyzeSongCallback = function(data, textStatus, jqXHR) {
    var analysis_url;
    console.log(data);
    console.log("Retrieving analysis for " + data.response.track.title);
    console.log("Analysis url is " + data.response.track.audio_summary.analysis_url);
    analysis_url = data.response.track.audio_summary.analysis_url;
    return this.retrieveAnalysis(analysis_url);
  };
  Track.prototype.retrieveAnalysis = function(analysis_url) {
    return $.ajax({
      type: 'GET',
      url: "/track_analysis",
      data: {
        analysis_url: analysis_url
      },
      success: this.retrieveAnalysisCallback,
      error: this.errorCallback,
      dataType: "json"
    });
  };
  Track.prototype.retrieveAnalysisCallback = function(data, textStatus, jqXHR) {
    console.log("RETRIEVE ANALYSIS CALLBACK");
    console.log(data);
    this.beats = data.beats;
    this.song_end = data.track.duration * 1000;
    return this.setSongURL();
  };
  Track.prototype.setSongURL = function() {
    return $.ajax({
      type: 'GET',
      url: "/get_fma_track_url",
      data: {
        track_url: "http://freemusicarchive.org/services/playlists/embed/track/" + this.fma_id + ".xml"
      },
      success: this.setSongURLCallback,
      error: this.errorCallback,
      dataType: "xml"
    });
  };
  Track.prototype.setSongURLCallback = function(data, textStatus, jqXHR) {
    console.log(data);
    this.track_url = $(data).find("download").text();
    if (this.ready_callback != null) {
      return this.ready_callback();
    }
  };
  Track.prototype.errorCallback = function(jqXHR, textstatus, error_thrown) {
    return console.error("there was an error", jqXHR, textstatus, error_thrown);
  };
  Track.prototype.getSongEnd = function() {
    return this.song_end;
  };
  Track.prototype.getTrackUrl = function() {
    return this.track_url;
  };
  Track.prototype.getBeats = function() {
    var actual_beats, beat, _i, _len, _ref;
    actual_beats = [];
    _ref = this.beats;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      beat = _ref[_i];
      if (beat.confidence > 0.4) {
        actual_beats.push(beat.start * 1000);
      }
    }
    return actual_beats;
  };
  return Track;
})();
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
    this.start = __bind(this.start, this);
    this.stop = __bind(this.stop, this);
    this._event_queue = [];
    this.rate = 15;
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
  EventQueue.prototype.stop = function(e) {
    console.log(e, e.jPlayer.status);
    console.log("STOPPING");
    this.playing = false;
    return clearTimeout(this.timeout);
  };
  EventQueue.prototype.start = function(e) {
    console.log("STARTING");
    return this.playing = true;
  };
  EventQueue.prototype.seekTo = function(seek_time) {
    this.seek_time = seek_time;
    if (this.playing !== true) {
      return;
    }
    console.log("SEEKING TO: " + this.seek_time);
    if (this.timeout != null) {
      console.log("CLEARING TIMEOUT: " + this.timeout);
      clearTimeout(this.timeout);
    }
    return this._runEventQueue(this.seek_time);
  };
  EventQueue.prototype._runEventQueue = function(start_time) {
    var item, next_start_time, _i, _len, _ref, _ref2;
    console.log("Frame: " + start_time);
    if (this.seek_time > start_time) {
      return;
    }
    _ref = this._event_queue;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      if ((start_time - this.rate <= (_ref2 = item.time) && _ref2 <= start_time + this.rate)) {
        item.animation.apply(item.element);
        console.log("Playing: '" + item.element + "'");
      }
    }
    next_start_time = start_time + this.rate;
    return this.timeout = setTimeout(__bind(function() {
      return this._runEventQueue(next_start_time);
    }, this), this.rate);
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
  track = new Track("TRBOFQJ131BAB774CC", 34681);
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
    jp$.bind(jEvent.timeupdate, function(e) {
      var t;
      t = e.jPlayer.status.currentTime * 1000;
      console.log("Time update:", t);
      return event_queue.seekTo(t);
    });
    jp$.bind(jEvent.abort, event_queue.stop);
    jp$.bind(jEvent.pause, event_queue.stop);
    jp$.bind(jEvent.ended, event_queue.stop);
    return jp$.bind(jEvent.play, event_queue.start);
  };
  return track.ready(trackReady);
});
appear = function(word) {
  return $("#animation").html(word);
};
searchSongs = function() {
  var mood;
  mood = $("input:radio[name=mood]:checked").val();
  console.log(mood);
  return $.ajax({
    type: 'GET',
    url: "http://developer.echonest.com/api/v4/song/search?bucket=id:fma&bucket=tracks",
    data: {
      api_key: "CJMTSEJKZGMYYF9UI",
      mood: mood,
      limit: "true"
    },
    success: searchSongsCallback,
    error: errorCallback,
    dataType: "json"
  });
};
searchSongsCallback = function(data, textStatus, jqXHR) {
  var echonest_track_id, fma_id, song;
  console.log("SEARCH SONGS CALLBACK");
  console.log(data);
  song = data.response.songs[0];
  fma_id = song.tracks[0].foreign_id;
  echonest_track_id = song.tracks[0].id;
  console.log("SONG: " + song.title + " ARTIST: " + song.artist_name + "TRACK ID: " + echonest_track_id + " FMA ID: " + fma_id);
  $("input:hidden[name=fma-id]").val(fma_id);
  return $("input:hidden[name=echonest-track-id]").val(echonest_track_id);
};
errorCallback = function(jqXHR) {
  console.log("ERROR");
  return console.log(jqXHR);
};