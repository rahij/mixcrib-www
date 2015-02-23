"use strict";

module.exports = SpotifyRemoteClient;

function SpotifyRemoteClient(host) {
  this.host                  = host || window.location.hostname;
  this.elements              = [];
  this._rangeInputBlocked    = false;
  this._sendRangeInput       = false;
  this._rememberedRangeInput = 0;
}

SpotifyRemoteClient.prototype.init = function(io) {
  this.io = io('http://localhost:8000');

  this.connect();
  this.bindDOMEvents();
  this.bindVisibilityEvents();
};

SpotifyRemoteClient.prototype.connect = function() {
  if (this.socket && this.socket.socket.connected) return;

  if (!this.socket) {
    this.socket = this.io.connect(this.host);
  } else {
    this.socket.socket.connect(); // reuse previous socket and simply reconnect
  }

  this.socket.on('currentTrack', this.showCurrentTrack.bind(this));
  this.socket.on('currentState', this.showCurrentState.bind(this));
  this.socket.on('currentArtwork', this.showCurrentArtwork.bind(this));
};

SpotifyRemoteClient.prototype.disconnect = function() {
  this.socket.disconnect();
  this.socket.removeAllListeners();
};

SpotifyRemoteClient.prototype.bindDOMEvents = function() {
  var self = this;

  document.addEventListener('click', function(event) {
    var command = {
      'previous': 'previous',
      'next': 'next',
      'current-play-state': 'playPause'
    }[event.target.id];

    if (!command) return;

    self.emit(command);
    event.preventDefault();
  });

  document.addEventListener('keyup', function(event) {
    if (event.target.tagName === 'INPUT') return;

    var command = {
      32: 'playPause',   // space
    }[event.keyCode];

    if (command) self.emit(command);
  });

  // position control
  this.bindRangeInputEvents('position', 'jumpTo');

  document.addEventListener('click', function(event) {
    var showPage = {
      'search': self.showSearchPage,
      'remote': self.showRemotePage,
      'artist-detail': self.showArtistDetailPage
    }[event.target.dataset.showPage];

    if (!showPage) return;

    event.preventDefault();

    if (event.target.dataset.deleteLastVisited === '') delete self.lastVisitedPage;
    showPage.call(self);
  });

  document.addEventListener('click', function(event) {
    if (event.target.className !== 'show-more') return;
    event.preventDefault();

    self.showMoreResults(event.target.rel);
  });
};

SpotifyRemoteClient.prototype.bindRangeInputEvents = function(id, emitName) {
  var self = this;

  this.$(id).addEventListener('change', function(event) {
    clearInterval(self._rangeInputInterval);
    self._rememberedRangeInput = event.target.value;

    self._rangeInputInterval = setInterval(function() {
      if (self._sendRangeInput) {
        self.emit(emitName, self._rememberedRangeInput);
        self._rangeInputBlocked = false;
        self._sendRangeInput    = false;
        clearInterval(self._rangeInputInterval);
      }
    }, 100);
  });

  this.$(id).addEventListener('mousedown', function() {
    clearInterval(self._rangeInputInterval);
    self._rangeInputBlocked = true;
  });

  this.$(id).addEventListener('mouseup', function() {
    self._sendRangeInput = true;
  });
};

SpotifyRemoteClient.prototype.bindVisibilityEvents = function() {
  var self                 = this;
  var bindVisibilityChange = function(eventName, propertyName) {
    document.addEventListener(eventName, function() {
      document[propertyName] ? self.disconnect() : self.connect();
    });
  };

  if (typeof document.hidden !== 'undefined') {
    return bindVisibilityChange('visibilitychange', 'hidden');
  } else if (typeof document.webkitHidden !== 'undefined') {
    return bindVisibilityChange('webkitvisibilitychange', 'webkitHidden');
  } else if (typeof document.msHidden !== 'undefined') {
    return bindVisibilityChange('msvisibilitychange', 'msHidden');
  }

  if (typeof window.onpagehide !== 'undefined') {
    window.addEventListener('pagehide', this.disconnect.bind(this));
    window.addEventListener('pageshow', this.connect.bind(this));
  }
};

SpotifyRemoteClient.prototype.showCurrentTrack = function(track) {
  // don't rerender stuff when nothing has changed
  if (this.currentTrack && this.currentTrack.id === track.id) return;

  this.$('artist').textContent   = track.artist;
  this.$('name').textContent     = track.name;
  this.$('duration').textContent = this.formatTime(track.duration);
  this.$('position').setAttribute('max', track.duration);

  this.currentTrack = track;
};

SpotifyRemoteClient.prototype.showCurrentState = function(state) {
  if (!this.currentState || this.currentState.position !== state.position) {
    this.$('played-time').textContent = this.formatTime(state.position);

    if (!this._positionRangeBlocked) this.$('position').value = state.position;
  }

  if (!this.currentState || this.currentState.state !== state.state) {
    this.$('current-play-state').textContent = state.state === 'paused' ? 'Play' : 'Pause';
  }

  this.currentState = state;
};

SpotifyRemoteClient.prototype.showCurrentArtwork = function(artwork) {
  this.$('artwork').src = 'data:image/png;base64,' + artwork;
};

SpotifyRemoteClient.prototype.emit = function(event, data) {
  if (this.socket) this.socket.emit(event, data);
};

// jQuery.
SpotifyRemoteClient.prototype.$ = function(id) {
  this.elements[id] = this.elements[id] || document.getElementById(id);

  return this.elements[id];
};

SpotifyRemoteClient.prototype.forEach = function(obj, iterator, context) {
  Array.prototype.forEach.call(obj, iterator, context);
};

SpotifyRemoteClient.prototype.formatTime = function(totalSeconds) {
  var minutes = Math.floor(totalSeconds / 60);
  var seconds = totalSeconds % 60;

  minutes = minutes < 10 ? '0' + minutes : minutes;
  seconds = seconds < 10 ? '0' + seconds : seconds;

  return minutes + ":" + seconds;
};

SpotifyRemoteClient.prototype.handleTracksResultClick = function(target) {
  this.socket.emit('playTrack', target.dataset.spotifyurl);
  this.showRemotePage();
};

SpotifyRemoteClient.prototype.playTrack = function(spotifyurl) {
  this.socket.emit('playTrack', spotifyurl);
}

SpotifyRemoteClient.prototype.pauseCurrentTrack = function() {
  this.socket.emit('playPause')
}