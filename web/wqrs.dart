library wqrs.web.app;



import 'package:wqrs/services/session.dart';
import 'package:wqrs/services/event_listeners.dart';
import 'package:wqrs/handlers.dart';
import 'package:wqrs/transport.dart';


void main() {

  new Wqrs();
}

class Wqrs {
  Session session;
  EventHandlers handlers;
  Transporter transport;
  EventListeners eventListeners;

  Wqrs() {
    if(!isCapable()) return;
    
    session = new Session();
    handlers = new EventHandlers();
    transport = new Transporter();
    transport.run();
    
    eventListeners = new EventListeners(transport, session, handlers);
    
  }
  /**
   * TODO: create function that detect's if all modules can run in current blowser.
   */
  bool isCapable(){
    return true;
  }
  
}