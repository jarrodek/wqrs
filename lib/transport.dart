library wqrs.lib.services.transport;

import 'dart:convert';

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
