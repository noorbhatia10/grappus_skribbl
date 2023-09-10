import 'dart:async';

import 'package:api/utils/src/ticker.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/models.dart';

class RoundEndDialog extends StatefulWidget {
  const RoundEndDialog({super.key});

  @override
  State<RoundEndDialog> createState() => _RoundEndDialogState();
}

class _RoundEndDialogState extends State<RoundEndDialog> {
  final Ticker _ticker = const Ticker();
  int remainingSeconds = 5;
  late StreamSubscription<int> _tickerSub;

  @override
  void initState() {
    super.initState();
    _tickerSub = _ticker.tick(ticks: 5).listen(
          (duration) => setState(() {
            remainingSeconds = duration;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Improve UI for this dialog
    return BlocConsumer<GameCubit, GameState>(
      builder: (context, state) => Center(
        child: Card(
          child: Container(
            height: context.screenHeight / 2,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Correct Answer:${state.sessionState?.correctAnswer ?? ''}',
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Next Round Starting In:$remainingSeconds',
                ),
              ],
            ),
          ),
        ),
      ),
      listener: (context, state) {
        if (state.sessionState == null) {
          return;
        }
        if (remainingSeconds == 0 &&
            state.sessionState!.eventType == EventType.roundStart) {
          _tickerSub.cancel();
          context.pop();
        }
      },
    );
  }
}
