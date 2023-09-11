import 'package:dio/dio.dart';
import 'package:services/src/endpoints.dart';

class GameService {
  final _dioClient = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      responseType: ResponseType.json,
      headers: {Headers.contentTypeHeader: 'application/json'}));

  Future<Response> connect({
    required String name,
    required String image,
    required int color,
  }) async {
    var future = await _dioClient
        .post('/connect', data: {'name': name, 'image': image, 'color': color});
    return future;
  }
}
