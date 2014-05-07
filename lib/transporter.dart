library wqrs.lib.transporter;

import 'dart:async';

import 'app_events.dart';
import 'session_manager.dart';

/**
 * A package ready to send to the server.
 * It contains all necessary data to be recognized by the server. 
 */
class TransportPackage {
  List<AppEvent> _events = new List<AppEvent>();
  int _length = 0;
  SessionManager _sessionManager;

  TransportPackage(this._sessionManager);

  int get length => _length;

  void add(AppEvent event) {
    this._events.add(event);
    _length ++;
  }

  String toString () {
    
  }
}

/**
 * A class responsible for data transport. 
 */
class DataTransporter {
  List<TransportPackage> _queue = new List<TransportPackage>();
  String SERVER_ADDR = "http://127.0.0.1";
  String EVENT_PUT_URI = "/collect";

  Future send (TransportPackage package) {
    
  }
}