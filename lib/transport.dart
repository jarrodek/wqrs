library wqrs.lib.services.transport;

import 'dart:convert';
import 'dart:async';

class EventType {
  static const String SCROLL = 'sc';
  static const String CLICK = 'cl';
  static const String KEYDOWN = 'kd';
  static const String MOUSE_MOVE = 'mm';
}

/**
 * Basic data object.
 * If contains required information to be passed to the server.
 */
class EventObject {
  /// User ID
  String uid;
  /// Sessin ID
  String sid;
  /*/// Event time. It is value from window.performance.now() which is the time since page load. 
  double pagetime;*/
  /// Event time. It is a [DateTime] value.
  DateTime time;
  /// Event type.
  String type;

  EventObject();

  EventObject.fromData(this.uid, this.sid,  /*this.pagetime,*/
  this.time, this.type);

  Map getMap() {
    Map map = {
      'ui': uid,
      'si': sid,
      'tm': time.millisecondsSinceEpoch,
      'tp': type
    };
    return map;
  }
}

class AppPoint {
  int x;
  int y;
  double pagetime;
  AppPoint(this.x, this.y, this.pagetime);
  Map toJson() {
    Map map = new Map();
    map["x"] = x;
    map["y"] = y;
    map["pt"] = pagetime;
    return map;
  }
}

class EventMouseMove extends EventObject {

  List<AppPoint> sequence = new List<AppPoint>();

  EventMouseMove(String uid, String sid,  /*double pagetime,*/
  DateTime time, String type): super.fromData(uid, sid, /*pagetime,*/ time, type);

  void append(AppPoint point) {
    sequence.add(point);
  }

  String toString() {
    Map map = getMap();
    map['sq'] = sequence;
    return JSON.encode(map);
  }
}

class CoordinateEvent extends EventObject {
  /// Event time. It is value from window.performance.now() which is the time since page load. 
  double pagetime;
  int x;
  int y;
  
  CoordinateEvent(String uid, String sid, this.pagetime, DateTime time, String type, this.x, this.y): super.fromData(uid, sid, time, type);
  
  String toString() {
    Map map = getMap();
    map['pt'] = pagetime;
    map['x'] = x;
    map['y'] = y;
    return JSON.encode(map);
  }
}


/**
 * The [Transporter] class is responsible to packing events in a packet (depends on event type) and send it to the server.
 */
class Transporter {
  
  List _eventsToSend = [];
  Map<String, EventObject> _appEvents = new Map<String, EventObject>();
  bool _activated = false;
  bool get active => _activated;
  
  ///Activate [Transporter] and wait for new events. 
  void run(){
    if(_activated) return;
    
    var stream = new Stream.fromIterable(_eventsToSend);
    stream.listen(_send);
    
    _activated = true;
  }
  
  void _send(dynamic data){
    
  }
  
  void appendEvent(EventObject data){
    String type = data.type;
    if(_appEvents.containsKey(type)){
      
    }
    
  }
}