library wqrs.lib.sessionmanager;

import 'dart:html';

import 'package:uuid/uuid_client.dart';

import 'storage.dart';

/**
 * A class responsible for session handling.  
 * Each user visit on the website is one session. Session is considered as a 30 minutes of user activity.
 * After this time if user did nothing on the website the session will expire and new one will be created.
 * 
 * One session have at least one pageview.
 * 
 * Each pageview has at least one action (load [DateTime] as a timestamp).
 */
class SessionManager {
  ///Cached user id. This field shouldn't change when creating new instance.
  String _uid;
  ///Cached session ID, This field shouldn't change when createing new instance.
  String _sid;
  ///Latest action timestamp
  double _actionTime;
  /// User ID
  String get uid => _uid == null ? getOrCreateUid() : _uid;
  /// Session ID
  String get sid => _sid == null ? getOrCreateSid() : _sid;
  ///Time of valid session length in seconds. After this time of inactivity new session will be created.
  static int sessionLength = 1800;

  ///Generates random UID
  static String createUid() {
    var uuid = new Uuid();
    String newUuid = uuid.v4();
    window.localStorage[StorageKeys.USER_ID] = newUuid;
    return newUuid;
  }

  ///Get existing UID or create one 
  String getOrCreateUid() {
    String uuid = window.localStorage[StorageKeys.USER_ID];
    if (uuid == null) {
      uuid = createUid();
    }
    _uid = uuid;
    return uuid;
  }

  ///Generate new SID 
  static String createSid() {
    var uuid = new Uuid();
    String sid = uuid.v1();
    window.localStorage[StorageKeys.SESSION_ID] = sid;
    window.localStorage[StorageKeys.SESSION_ACTION_TIME] = (new DateTime.now().millisecondsSinceEpoch/1000).toString();
    return sid;
  }

  ///Get existing SID or create one
  String getOrCreateSid() {
    String lastSid = window.localStorage[StorageKeys.SESSION_ID];
    if(lastSid == null){
      lastSid = createSid();
    } else {
      if(_actionTime == null){
        String lastActionTime = window.localStorage[StorageKeys.SESSION_ACTION_TIME];
        if(lastActionTime == null || lastActionTime.isEmpty){
          _actionTime = new DateTime.now().millisecondsSinceEpoch/1000;
          window.localStorage[StorageKeys.SESSION_ACTION_TIME] = _actionTime.toString();
        } else {
          if(_isSessionExpored(int.parse(lastActionTime))){
            lastSid = createSid();
          }
        }
      } else {
        if(_isSessionExpored()){
          lastSid = createSid();
        }
      }
    }
    _sid = lastSid;
    return lastSid;
  }
  
  ///Event listeners should notify session manager if any event (action) occured.
  set actionTime(double timestamp) {
    _actionTime = timestamp;
    window.localStorage[StorageKeys.SESSION_ACTION_TIME] = timestamp.toString();
  }
  
  ///Check if session expored after [sessionLength] of inactivity
  bool _isSessionExpored([int timestamp]){
    timestamp = timestamp == null ? _actionTime : timestamp;
    if(timestamp == null) return false;
    DateTime t = new DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    return new DateTime.now().isBefore(t.add(new Duration(seconds: sessionLength)));
  }

  Map toJson() {
    return {
      'sid': sid,
      'uid': uid
    };
  }

}
