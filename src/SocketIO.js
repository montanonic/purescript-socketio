"use strict";

// module SocketIO

exports.stringify = function stringify(x) {
  return JSON.stringify(x);
};

exports.connect = function connect(host) {
  return function() {
    return io.connect(host);
  };
};

exports.onMsgImpl = function onImpl(sock, channel, onMessage) {
  return function() {
    sock.on(channel, function(m){ 
      onMessage(m)();
    });
  };
};

exports.emitImpl = function emitImpl(sock, channel) {
  return function() {
    sock.emit(channel);
  };
};

exports.emitMsgImpl = function emitMsgImpl(sock, channel, emitMessage) {
  return function() {
    sock.emit(channel, emitMessage);
  };
};
