import 'package:flutter/material.dart';

class Constants {
  
  
  static const dommain = 'https://balsam.academy';
  static const baseUrl = '$dommain/api/production/';
  static const apiKey = 'base64:BlQYTmcfZGV4XShvK5Z+ffNVWv0qszkUTReQGmD76lw=';
  static const scheme = 'balsamacademy';
  
  static final RouteObserver<ModalRoute<void>> singleCourseRouteObserver = RouteObserver<ModalRoute<void>>();
  static final RouteObserver<ModalRoute<void>> contentRouteObserver = RouteObserver<ModalRoute<void>>();

}
