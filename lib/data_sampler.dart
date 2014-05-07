library wqrs.lib.datasampler;

import 'dart:async';
import 'dart:html';

import 'app_events.dart';

/**
 * Samples data before sending it to DataCollector.
 */
class DataSampler {
  Map<String, List> _queue = new Map<String, List>();
  StreamController<List<AppEvent>> _streamController;
  Stream<List<AppEvent>> _broadcastStream;

  DataSampler() {
    _streamController = new StreamController<List<AppEvent>>();
    _broadcastStream = _streamController.stream.asBroadcastStream();
  }

  /// Add element to the queue
  void add (dynamic e) {
    if(e is AppEvent){
      _addEvent(e);
    } else if (e is AppPoint){
      _addMovePoint(e);
    }
    window.console.log('Appended data to the DataSampler');
    window.console.log(e.toJson().toString());
  }
  ///Add event type element to the queue
  void _addEvent(AppEvent e){
    if(!_queue.containsKey(e.type)){
      _queue[e.type] = new List<AppEvent>();
    }
    _queue[e.type].add(e);
    sample(e.type);
  }
  /// Add mouse move point to the queue.
  void _addMovePoint(AppPoint e){
    if(!_queue.containsKey(AppEventType.MOUSE_MOVE)){
      _queue[AppEventType.MOUSE_MOVE] = new List();
    }
    _queue[AppEventType.MOUSE_MOVE].add(e);
    sample(AppEventType.MOUSE_MOVE);
  }

  /// sample data based on the type
  void sample (String type) {
    switch(type){
      case 'mm': sampleMouseMove(); break;
      case 'sc': sampleScroll(); break;
    }
  }

  ///TODO Sample mouse move events.
  void sampleMouseMove () {
    
  }

  ///TODO Sample scroll events.
  void sampleScroll () {
    
  }

  Stream<List<AppEvent>> get broadcastStream => _broadcastStream;

  /** 
   * On page unload get all unprocessed items and send it. 
   */
  List<AppEvent> getAndClear () {
    List<AppEvent> list = new List<AppEvent>();
    _queue.forEach((type, events) {
      if(type == AppEventType.MOUSE_MOVE){
        double timestamp = new DateTime.now().millisecondsSinceEpoch/1000;
        MoveAppEvent ev = new MoveAppEvent(AppEventType.MOUSE_MOVE, timestamp);
        events.forEach((e) => ev.append(e));
        list.add(ev);
      } else {
        list.addAll(events);
      }
    });
    _queue.clear();
    
    return list;
  }

}