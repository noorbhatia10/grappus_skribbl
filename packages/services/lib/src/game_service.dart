import 'package:dio/dio.dart';
import 'package:services/src/endpoints.dart';

class GameService {
  final _dioClient = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      responseType: ResponseType.json,
      headers: {Headers.contentTypeHeader: 'application/json'}));

  Future<Response> connect() async {
    var future = await _dioClient.get('/connect');
    return future;
  }
}
