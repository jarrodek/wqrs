library wqrs.lib.services.datacollector;

import 'dart:html';

import 'package:browser_detect/browser_detect.dart' as br;

import 'session.dart';

/**
 * This class is responsible for getting all browser information. 
 */
class DataCollector {
  
  /// Session data (uid & ssid)
  Session session;
  
  DataCollector(this.session);
  
  /// Browser's name
  String get browser => br.browser.name;
  /// Browser's version
  String get browserVersion => br.browser.version.value;
  ///current page full URL
  String get url => window.location.href;
  /// Page title.
  String get pageTitle => document.title;
  
  String get viewPort => "${window.outerWidth}x${window.outerHeight}";
  
  Map toJson(){
    return {
      'u': url,
      'b': browser,
      'bv': browserVersion,
      'pt': pageTitle,
      'ui': session.uid,
      'si': session.sid,
      'vp': viewPort
    };
  }
}