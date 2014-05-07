library wqrs.web.app;



import 'package:wqrs/data_collector.dart';


void main() {

  new Wqrs();
}

class Wqrs {
  DataCollector dataCollector;

  Wqrs() {
    if(!isCapable()) return;
    dataCollector = new DataCollector();
    dataCollector.registerListeners();
  }
  /**
   * TODO: create function that detect's if all modules can run in current blowser.
   */
  bool isCapable(){
    return true;
  }
  
}