library wqrs.lib.eventcollector;

import 'dart:async';
import 'dart:html';

import 'app_events.dart';

/**
 * This class is responsible for broswers events handling and sending them to [DataCollector]. 
 */
class EventCollector {
  StreamController<Map> _streamController;
  Stream<Map> _broadcastStream;
  
  static final String MOUSE_MOVE = "mm";
  static final String MOUSE_CLICK = "mc";
  static final String WINDOW_SCROLL = "ws";
  static final String KEY_PRESSED = "kp";
  static final String KEY_RELEASED = "kr";
  static final String PAGE_UNLOAD = "pu";
  static final String PAGE_LOAD = "pl";

  EventCollector() {
    _streamController = new StreamController<Map>();
    _broadcastStream = _streamController.stream.asBroadcastStream();
    _registerMouseEvents();
    _registerScrollEvents();
    _registerKeyEvents();
    _registerUnloadEvent();
    _registerLoadEvent();
  }

  Stream<Map> get broadcastStream => _broadcastStream;

  void _registerMouseEvents () {
    window.onMouseMove.listen((MouseEvent event) {
      Map obj = {
        'type': AppEventType.MOUSE_MOVE,
        'x': event.client.x,
        'y': event.client.y
      };
      _streamController.add(obj);
    });
    
    window.onClick.listen((MouseEvent e){
      Map obj = {
        'type': AppEventType.CLICK,
        'x': e.client.x,
        'y': e.client.y
      };
      _streamController.add(obj);
    });
  }

  void _registerScrollEvents () {
    window.onScroll.listen((Event e){
      Map obj = {
        'type': AppEventType.SCROLL,
        'dx': window.scrollX, //left
        'dy': window.scrollY  //top
      };
      _streamController.add(obj);
    });
  }

  void _registerKeyEvents () {
    window.onKeyPress.listen((KeyEvent e){
      Map obj = {
        'type': AppEventType.KEYPRESS,
        'code': e.charCode
      };
      _streamController.add(obj);
    });
  }

  void _registerUnloadEvent () {
    window.onUnload.listen((Event e){
      Map obj = {
        'type': AppEventType.UNLOAD
      };
      _streamController.add(obj);
    });
  }

  void _registerLoadEvent () {
    
  }

}