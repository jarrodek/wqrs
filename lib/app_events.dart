/**
 * A class representing an app point
 */
class AppPoint {
  /**
   * X position
   */
  int _x;
  /**
   * Y position
   */
  int _y;
  /**
   * Event fire time since page load.
   */
  double _relativeTime;

  AppPoint(this._x, this._y, this._relativeTime);
  /**
   * Creates a map from class values.
   */
  Map toJson() {
    Map map = new Map();
    map["x"] = _x;
    map["y"] = _y;
    map["pt"] = _relativeTime;
    return map;
  }
}

/**
 * Helper class to hold event names.
 */
class AppEventType {
  /**
   * Page scroll event
   */
  static final String SCROLL = "sc";
  /**
   * Mouse click event 
   */
  static final String CLICK = "cl";
  /**
   * Key pressed event
   */
  static final String KEYPRESS = "kp";
  /**
   * Mouse move event
   */
  static final String MOUSE_MOVE = "mm";
  /**
   * Page unload event
   */
  static final String UNLOAD = "un";
}

/**
 * Base class for apps events that will be send to server. 
 */
class AppEvent {
  /**
   * Sn event type. Values are defined in [AppEventType] class. 
   */
  String _type;
  /**
   * Event timestamp.
   */
  double _time;
  /**
   * Event's timestamp as number of seconds from Epoch.
   */
  double get time => _time;

  AppEvent(this._type, this._time);
  /**
   * Returns event type.
   */
  String get type => _type;
  /**
   * Creates a map from class values.
   */
  Map toJson() {
    Map map = {
      'tm': _time,
      'tp': _type
    };
    return map;
  }
}
/**
 * An event that represents position on the page.
 */
class PositionAppEvent extends AppEvent {
  /**
   * X position
   */
  int _x;
  /**
   * Y position
   */
  int _y;
  /**
   * Event fire time since page load.
   */
  double _relativeTime;

  PositionAppEvent(String type, double time, this._x, this._y, this._relativeTime): super(type, time);
  /**
   * Creates a map from class values.
   */
  Map toJson() {
    Map map = super.toJson();
    map["x"] = _x;
    map["y"] = _y;
    map["pt"] = _relativeTime;
    return map;
  }
}
/**
 * An event that represents move on the page
 */
class MoveAppEvent extends AppEvent {
  /**
   * Move events sequence. 
   * It is inefficient to send each move event separatly so it will be send to the server in a package.
   */
  List<AppPoint> _sequence = new List<AppPoint>();

  MoveAppEvent(String type, double time): super(type, time);
  /**
   * Add point to a package.
   */
  void append(AppPoint point) {
    _sequence.add(point);
  }
  /**
   * Creates a map from class values.
   */
  Map toJson() {
    Map map = super.toJson();
    map['sq'] = _sequence;
    return map;
  }
}

/**
 * Anevent that represents keyboard event. 
 */
class KeycodeAppEvent extends AppEvent {
  /**
   * Key code
   */
  int _keyCode;
  /**
   * Event fire time since page load.
   */
  double _relativeTime;

  KeycodeAppEvent(String type, double time, this._keyCode, this._relativeTime): super(type, time);
  /**
   * Creates a map from class values.
   */
  Map toJson() {
    Map map = super.toJson();
    map['kc'] = _keyCode;
    map["pt"] = _relativeTime;
    return map;
  }
}
