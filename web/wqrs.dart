library wqrs.web.app;

import 'dart:html';

import 'package:wqrs/services/session.dart';
import 'package:wqrs/handlers.dart';
import 'package:wqrs/transport.dart';


void main() {

  new Wqrs();
}

class Wqrs {
  Session session;
  EventHandlers handlers;

  Wqrs() {
    session = new Session();
    handlers = new EventHandlers();

    _handleMouse();
    _handleScroll();
  }
  
  void _handleMouse() {

    EventMouseMove _tempEv;

    handlers.broadcastStream
      .where((Map i) => i['type'] == EventHandlers.MOUSE_MOVE)
      .listen((Map value) {
        if (_tempEv == null) {
          _tempEv = new EventMouseMove(session.uid, session.sid, new DateTime.now(), EventType.MOUSE_MOVE);
        }
        _tempEv.append(new AppPoint(value['x'], value['y'], window.performance.now()));
        if (_tempEv.sequence.length > 50) {
          //send to server
          //window.console.log(_tempEv.toString());
          _tempEv = null;
        }
      });
  }

  void _handleScroll() {
    handlers.broadcastStream
      .where((Map i) => i['type'] == EventHandlers.WINDOW_SCROLL)
      .listen((Map value) {
        //value['dx']
        //value['dy']
        window.console.log(value['dy']);
      });
  }
}