library wqrs.lib.services.event_listeners;

import 'dart:html';

import '../transport.dart';
import '../handlers.dart';
import 'session.dart';

class EventListeners {
  Transporter transport;
  Session session;
  EventHandlers handlers;
  
  EventListeners(this.transport, this.session, this.handlers);
  
  void initialize(){
    _handleMouse();
    _handleScroll();
  }
  
  void _handleMouse() {
      handlers.broadcastStream
        .where((Map i) => i['type'] == EventHandlers.MOUSE_MOVE)
        .listen(_handleMouseMove);
      handlers.broadcastStream
            .where((Map i) => i['type'] == EventHandlers.MOUSE_CLICK)
            .listen(_handleMouseClick);
    }
    
    EventMouseMove _tempEv;
    void _handleMouseMove(Map value){
      if (_tempEv == null) {
        _tempEv = new EventMouseMove(session.uid, session.sid, new DateTime.now(), EventType.MOUSE_MOVE);
      }
      _tempEv.append(new AppPoint(value['x'], value['y'], window.performance.now()));
      if (_tempEv.sequence.length > 50) {
        //send to server
        //window.console.log(_tempEv.toString());
        transport.appendEvent(_tempEv);
        _tempEv = null;
      }
    }
    
    void _handleMouseClick(Map value){
      CoordinateEvent ev = new CoordinateEvent(session.uid, session.sid, window.performance.now(), new DateTime.now(), EventType.CLICK, value['x'], value['y']);
      transport.appendEvent(ev);
    }

    void _handleScroll() {
      handlers.broadcastStream
        .where((Map i) => i['type'] == EventHandlers.WINDOW_SCROLL)
        .listen((Map value) {
          CoordinateEvent ev = new CoordinateEvent(session.uid, session.sid, window.performance.now(), new DateTime.now(), EventType.SCROLL, value['dx'], value['dy']);
          transport.appendEvent(ev);
        });
    }
}