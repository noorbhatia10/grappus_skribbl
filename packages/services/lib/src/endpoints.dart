import 'package:flutter/foundation.dart';

class Endpoints {
  static const bool shouldLocalHost = false;

  static String get baseUrl =>
      kDebugMode ? localhostBaseUrl : serverHostUrl;

  static String get webSocketUrl =>
      kDebugMode ? localhostWebStockUrl : serverWebscoketUrl;

  static String localhostBaseUrl = 'http://localhost:8080';
  static String serverHostUrl =
      'https://graptoons-api.rpsite.top/';

  static String localhostWebStockUrl = 'ws://localhost:8080/ws';
  static const String serverWebscoketUrl =
      'wss://graptoons-api.rpsite.top/ws';
}
