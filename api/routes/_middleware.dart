import 'package:api/session/chat_bloc/chat_bloc.dart';
import 'package:api/session/points_bloc/points_bloc.dart';
import 'package:api/session/round_bloc/round_bloc.dart';
import 'package:api/utils/src/ticker.dart';
import 'package:dart_frog/dart_frog.dart';

import '../headers/headers.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<RoundBloc>((context) => RoundBloc(ticker: const Ticker())))
      .use(provider<ChatBloc>((context) => ChatBloc()))
      .use(provider<PointsBloc>((context) => PointsBloc()))
      .use(corsHeaders());
}
