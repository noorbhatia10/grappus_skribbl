import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  final uid = const Uuid().v4();
  final request = context.request;

  final method = request.method.value;
  if (method != 'POST') {
    return Response(
      statusCode: 403,
      body: jsonEncode(
        {'status': 'error', 'message': 'should be a post method'},
      ),
    );
  }

  return Response(
    body: jsonEncode(
      {
        'status': 'success',
        'data': uid,
        'message': 'New room created',
      },
    ),
  );
}
