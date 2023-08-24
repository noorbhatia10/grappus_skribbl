import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';

import '../headers/headers.dart';

final _sessionBloc = SessionBloc();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SessionBloc>((context) => _sessionBloc))
      .use(corsHeaders());
}
