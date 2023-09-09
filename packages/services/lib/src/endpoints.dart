class Endpoints {
  static const bool shouldLocalHost = true;

  static String get baseUrl =>
      shouldLocalHost ? localhostBaseUrl : serverHostUrl;

  static String get webSocketUrl =>
      shouldLocalHost ? localhostWebStockUrl : serverWebscoketUrl;

  static String localhostBaseUrl = 'http://localhost:8080';
  static String serverHostUrl =
      'http://ec2-13-51-233-255.eu-north-1.compute.amazonaws.com';

  static String localhostWebStockUrl = 'ws://localhost:8080/ws';
  static const String serverWebscoketUrl =
      'ws://ec2-13-51-233-255.eu-north-1.compute.amazonaws.com/ws';
}
