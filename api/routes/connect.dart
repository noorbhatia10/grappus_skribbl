import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

Response onRequest(RequestContext context) {
  final uid = const Uuid().v4();

  return Response(
    body: jsonEncode({'status': 'success', 'data': uid}),
  );
}
