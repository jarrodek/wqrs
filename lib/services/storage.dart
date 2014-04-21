library wqrs.lib.services.storage;

import 'dart:html';

abstract class Storage<K, V> {
  void store(K key, V value);
  V restore(K key);
  V operator [](K key);
  final String KEY_USER_ID = 'wqrs_uuid';
  final String KEY_SESSION_ID = 'wqrs_sid';
  final String KEY_SESSION_ACTION_TIME = 'wqrs_sida';
}

class SessionStorage extends Storage<String, String> {
  
  void store(String key, String value){
    window.sessionStorage[key] = value;
  }
  
  String restore(String key){
    return this[key];
  }
  
  String operator [](String key){
    return window.sessionStorage[key];
  }
}

class LocalStorage extends Storage<String, String> {
  
  void store(String key, String value){
    window.localStorage[key] = value;
  }
  
  String restore(String key){
    return this[key];
  }
  
  String operator [](String key){
    return window.localStorage[key];
  }
}