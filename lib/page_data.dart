library wqrs.lib.pagedata;

import 'dart:html';

import 'package:browser_detect/browser_detect.dart' as br;

class PageviewData {
  /// Browser's name
  String get browserName => br.browser.name;
  /// Browser's version
  String get browserVersion => br.browser.version.value;
  ///current page full URL
  String get pageUrl => window.location.href;
  /// Page title.
  String get pageTitle => document.title;
  ///page load timestamp
  int timestamp;
  ///page load time from start to dom loaded event
  double loadtime;
  ///Page width.
  int get width => window.outerWidth;
  ///Page height
  int get height => window.outerHeight;
  
  PageviewData(this.timestamp, this.loadtime);

  /** 
   * Create map of values 
   */
  Map toJson () {
    return {
      'u': pageUrl,
      'b': browserName,
      'bv': browserVersion,
      'pt': pageTitle,
      'w': width,
      'h': height
    };
  }

}