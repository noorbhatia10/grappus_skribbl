import 'package:flutter/foundation.dart';

class Endpoints {
  static const bool shouldLocalHost = false;

  static String get baseUrl =>
      kDebugMode ? localhostBaseUrl : serverHostUrl;

  static String get webSocketUrl =>
      kDebugMode ? localhostWebStockUrl : serverWebscoketUrl;

  static String localhostBaseUrl = 'http://localhost:8080';
  static String serverHostUrl =
      'https://api.graptoons.fun/';

  static String localhostWebStockUrl = 'ws://localhost:8080/ws';
  static const String serverWebscoketUrl =
      'wss://api.graptoons.fun/ws';
}
