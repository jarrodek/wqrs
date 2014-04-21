library wqrs.lib.handlers;

import 'dart:async';
import 'dart:html';

class EventHandlers {
  
  static const String MOUSE_MOVE = 'mm';
  static const String MOUSE_CLICK = 'mc';
  static const String WINDOW_SCROLL = 'ws';
  
  StreamController<Map> controller;
  Stream<Map> broadcastStream;
  
  EventHandlers(){
    controller = new StreamController<Map>();
    broadcastStream = controller.stream.asBroadcastStream();
    this._registerMouseEvents();
    this._registerScrollEvents();
  }
  
  
  void _registerMouseEvents(){
    window.onMouseMove.listen((MouseEvent event) {
      Map obj = {
        'type': EventHandlers.MOUSE_MOVE,
        'x': event.client.x,
        'y': event.client.y
      };
      controller.add(obj);
    });
    
    window.onClick.listen((MouseEvent e){
      Map obj = {
        'type': EventHandlers.MOUSE_CLICK,
        'x': e.client.x,
        'y': e.client.y
      };
      controller.add(obj);
    });
    
  }
  
  void _registerScrollEvents(){
    
    window.onScroll.listen((Event e){
      Map obj = {
        'type': EventHandlers.WINDOW_SCROLL,
        'dx': window.scrollX, //left
        'dy': window.scrollY  //top
      };
      controller.add(obj);
    });
  }
  
}