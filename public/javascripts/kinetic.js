var Animator, EventQueue, Pixar, TestData, analyzeSong, analyzeSongCallback, appear, errorCallback, retrieveAnalysis, retrieveAnalysisCallback;
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
  function EventQueue(in_string, beats) {
    this.in_string = in_string;
    this.beats = beats;
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
Animator = (function() {
  function Animator() {}
  return Animator;
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
    console.log("Appending ", el$);
    return $("#animation").append(el$);
  };
  Pixar.postAnimate = function(el$) {};
  Pixar.animations = {
    fade: function(options) {
      console.log("Fade");
      return this.fadeIn('fast').delay(1000).fadeOut();
    },
    bump: function(options) {
      console.log("bump");
      return this.fadeIn('fast').delay(1000).fadeOut();
    },
    jump: function(options) {
      console.log("jump");
      return this.fadeIn('fast').delay(1000).fadeOut();
    }
  };
  return Pixar;
})();
jQuery(function() {
  var event_queue, jEvent, jp$;
  event_queue = new EventQueue(TestData.test_string, TestData.timestamps());
  jp$ = $("#jplayer");
  jEvent = $.jPlayer.event;
  jp$.jPlayer({
    ready: function() {
      return $(this).jPlayer("setMedia", {
        mp3: "http://www.minneapolisfuckingrocks.com/mp3/taylorswift_jumpthenfall1.mp3"
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
});
appear = function(word) {
  return $("#animation").html(word);
};
analyzeSong = function(song_id) {
  return $.ajax({
    type: 'POST',
    url: "http://developer.echonest.com/api/v4/track/analyze",
    data: {
      api_key: "CJMTSEJKZGMYYF9UI",
      id: song_id,
      bucket: "audio_summary"
    },
    success: analyzeSongCallback,
    error: errorCallback,
    dataType: "json"
  });
};
retrieveAnalysis = function(analysis_url) {
  return $.ajax({
    type: 'GET',
    url: analysis_url,
    success: function() {},
    error: errorCallback,
    dataType: "json"
  });
};
analyzeSongCallback = function(data, textStatus, jqXHR) {
  var analysis_url;
  console.log(data);
  if (data.response.status.message === "Success") {
    console.log("Retrieving analysis for " + data.response.track.title);
    console.log("Analysis url is " + data.response.track.audio_summary.analysis_url);
    analysis_url = data.response.track.audio_summary.analysis_url;
    return retrieveAnalysis(analysis_url);
  }
};
retrieveAnalysisCallback = function(data, textStatus, jqXHR) {
  return console.log(data);
};
errorCallback = function(jqXHR) {
  return alert("there was an error");
};
/*
{
    "response": {
        "status": {
            "version": "4.2",
            "code": 0,
            "message": "Success"
        },
        "track": {
            "status": "complete",
            "title": "Neverwas Restored (from Neverwas Soundtrack)",
            "artist": "Philip Glass",
            "id": "TRXXHTJ1294CD8F3B3",
            "analyzer_version": "3.01a",
            "release": "The Orange Mountain Music Philip Glass Sampler Vol.I",
            "audio_md5": "c2a69bd9db0b43725e36c0b092330da3",
            "bitrate": 224,
            "samplerate": 44100,
            "audio_summary": {
                "key": 7,
                "analysis_url": "https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=VI8tmWY%2B%2F6eq85H2G7kmb6e4eWI%3D&Expires=1282240751&AWSAccessKeyId=AKIAIAFEHLM3KJ2XMHRA",
                "tempo": 168.46,
                "mode": 1,
                "time_signature": 4,
                "duration": 120.68526,
                "loudness": -19.14,
                "danceability": .7,
                "energy": .9,
            },
            "md5": "b8abf85746ab3416adabca63141d8c2d"
        }
    }
}
*/