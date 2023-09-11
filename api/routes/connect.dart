import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
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

  // Get the value for the key `name`.
  // Default to `there` if there is no query parameter.
  final body = await request.body();
  final params = jsonDecode(body) as Map<String, dynamic>;
  final name = params['name'] as String?;
  final image = params['image'] as String?;
  final color = params['color'] as int?;
  if (name == null || image == null || color == null) {
    return Response(
      statusCode: 403,
      body: jsonEncode(
        {'status': 'error', 'message': 'name,image,color should not be null'},
      ),
    );
  }
  context.read<SessionBloc>().add(
        OnPlayerAdded(
          Player(
            userId: uid,
            name: name,
            imagePath: image,
            userNameColor: color,
          ),
        ),
      );

  return Response(
    body: jsonEncode({'status': 'success', 'data': uid}),
  );
}
