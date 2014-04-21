library wqrs.lib.services.session;

import 'dart:html';

import 'package:uuid/uuid_client.dart';
import 'storage.dart';

/**
 * A class to handle user sessions.
 * It will create user session if none existing and connect user pageviews accross session.
 */
class Session {
  
  ///User ID. This field shouldn't change when create new instance.
  static String _uid;
  ///Session ID. This field shouldn't change when create new instance.
  static String _sid;
  ///Time of valid session length n seconds. After this time of inactivity new session will be created.
  static int sessionLength = 1800;
  ///Each action on the page should result in action time change.
  static DateTime lastAction;
  
  LocalStorage localStorage;
  SessionStorage sessionStorage;
  
  Session() : 
    this.localStorage = new LocalStorage(), 
    this.sessionStorage = new SessionStorage();
  
  String get uid {
    if(Session._uid == null){
      Session._uid = _getExistingOrNewUid();
    }
    return Session._uid;
  }
  /**
   * Find in local storage app's uuid. If no uuid exists create one and store it in local storage.
   */
  String _getExistingOrNewUid(){
    String lastUuid = localStorage[localStorage.KEY_USER_ID];
    if(lastUuid == null){
      var uuid = new Uuid();
      lastUuid = uuid.v4();
      localStorage.store(localStorage.KEY_USER_ID, lastUuid);
    }
    return lastUuid;
  }
  /**
   * Get current session ID.
   * Session will expire after [sessionLength] seconds of user's inactivity and new session will be created.
   */
  String get sid{
    if(Session._sid == null){
      Session._sid = _getExistingOrNewSid();
    }
    return Session._sid;
  }
  
  String _getExistingOrNewSid(){
    String lastSid = sessionStorage[sessionStorage.KEY_SESSION_ID];
    if(lastSid == null){
      lastSid = _createSid();
    } else {
      String lastActionTime = sessionStorage[sessionStorage.KEY_SESSION_ACTION_TIME];
      if(lastActionTime == null){
        sessionStorage.store(sessionStorage.KEY_SESSION_ACTION_TIME, new DateTime.now().millisecondsSinceEpoch.toString());
      } else {
        DateTime t = new DateTime.fromMillisecondsSinceEpoch(int.parse(lastActionTime));
        if(new DateTime.now().isBefore(t.add(new Duration(seconds: sessionLength)))){
          //session expired
          lastSid = _createSid();
        }
      }
    }
    return lastSid;
  }
  
  String _createSid(){
    var uuid = new Uuid();
    String sid = uuid.v1();
    sessionStorage.store(sessionStorage.KEY_SESSION_ID, sid);
    sessionStorage.store(sessionStorage.KEY_SESSION_ACTION_TIME, new DateTime.now().millisecondsSinceEpoch.toString());
    return sid;
  }
}