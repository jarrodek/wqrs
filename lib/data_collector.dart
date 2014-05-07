library wqrs.lib.datacollector;

import 'dart:async';
import 'dart:html';

import 'app_events.dart';
import 'session_manager.dart';
import 'event_collector.dart';
import 'data_sampler.dart';
import 'page_data.dart';
import 'transporter.dart';


/**
 * A class responsible for collecting the data. 
 */
class DataCollector {
  PageviewData _pageview;
  Stream _eventsStream;
  TransportPackage _package;
  DataSampler _dataSampler;
  EventCollector _eventCollector;
  SessionManager _sessionManager;
  DataTransporter _transporter;
  bool _active = true;

  DataCollector() {
    //TODO: handle page load events. Check if initial javascript code already handled load events. If not register one and handle it. Use https://developer.mozilla.org/en-US/docs/Web/API/document.readyState
    _eventCollector = new EventCollector();
    _eventsStream = _eventCollector.broadcastStream;
    _dataSampler = new DataSampler();
    _sessionManager = new SessionManager();
    _transporter = new DataTransporter();
  }

  void registerListeners () {
    _eventsStream
      .where((Map i) => i['type'] == AppEventType.MOUSE_MOVE)
      .listen(_mouseMoveListener);
    _eventsStream
      .where((Map i) => i['type'] == AppEventType.CLICK)
      .listen(_mouseClickListener);
    _eventsStream
      .where((Map i) => i['type'] == AppEventType.SCROLL)
      .listen(_scrollListener);
    _eventsStream
      .where((Map i) => i['type'] == AppEventType.KEYPRESS)
      .listen(_keyPressListener);
    _eventsStream
      .where((Map i) => i['type'] == AppEventType.UNLOAD)
      .listen(_unloadListener);
    _dataSampler.broadcastStream.listen(_dataSamplerListener);
  }
  ///Mouse click events will be handled by package manager.
  void _mouseClickListener (Map event) {
    if(!_active) return;
    double timestamp = new DateTime.now().millisecondsSinceEpoch/1000;
    PositionAppEvent e = new PositionAppEvent(event['type'], timestamp, event['x'], event['y'], window.performance.now());
    append(e);
  }

  /// It will send an event to DataSampler
  void _mouseMoveListener (Map event) {
    if(!_active) return;
    AppPoint ap = new AppPoint(event['x'], event['y'], window.performance.now());
    _dataSampler.add(ap);
  }

  /// Send an event to DataSampler
  void _scrollListener (Map event) {
    if(!_active) return;
    double timestamp = new DateTime.now().millisecondsSinceEpoch/1000;
    PositionAppEvent ev = new PositionAppEvent(event['type'], timestamp, event['dx'], event['dy'], window.performance.now());
    
    _dataSampler.add(ev);
  }
  
  ///Key press events will be handled by package manager.
  void _keyPressListener (Map event) {
    if(!_active) return;
    double timestamp = new DateTime.now().millisecondsSinceEpoch/1000;
    KeycodeAppEvent e = new KeycodeAppEvent(event['type'], timestamp, event['code'], window.performance.now());
    append(e);
  }

  /** 
   * Listen for [DataSampler] stream events. 
   */
  void _dataSamplerListener (List<AppEvent> events) {
    if(!_active) return;
  }

  /** 
   * Listen for unload event and send all remaining data to the server. 
   */
  void _unloadListener (Map event) {
    if(!_active) return;
    List<AppEvent> ramains = _dataSampler.getAndClear();
    if(_package == null){
      _package = new TransportPackage(this._sessionManager);
    }
    ramains.forEach((AppEvent e) => _package.add(e));
    _sessionManager.actionTime = new DateTime.now().millisecondsSinceEpoch/1000;
    //TODO: handle package sending.
  }

  /** 
   * Append new event to package and notify Session manager about action.
   */
  void append (AppEvent event) {
    if(!_active) return;
    if(_package == null){
      _package = new TransportPackage(this._sessionManager);
    } else {
      _processPackage();
    }
    _package.add(event);
    _sessionManager.actionTime = event.time;
    window.console.log('Appended event to the package');
    window.console.log(event.toJson().toString());
  }

  /** 
   * Check size of package and send it if limit is exceeded. 
   * - Handle response error. If project does not exists it should prohibit from further requests. 
   */
  void _processPackage () {
    if(!_active) return;
    if(_package.length > 50){
      //TODO: send package
    }
  }

  /// End app's work and prohibit data collecting, sampling and sending.
  void shutDown () {
    _active = false;
    //TODO: turn off _eventsStream
  }

}