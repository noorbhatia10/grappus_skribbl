import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/views/game/view/chat_component.dart';
import 'package:grappus_skribbl/views/game/view/game_word.dart';
import 'package:grappus_skribbl/views/game/view/leader_board.dart';
import 'package:grappus_skribbl/views/game/view/round_end_dialog.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:models/models.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.url, required this.name, super.key});

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepository: GameRepository(
          uri: Uri.parse(url),
        ),
      )..connect(name),
      child: _GamePage(),
    );
  }
}

class _GamePage extends StatelessWidget {
  _GamePage();

  late List<DrawingPoints> pointsList = <DrawingPoints>[];
  bool isDialogOpened(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();

    final remainingTime =
        context.watch<GameCubit>().state.sessionState?.remainingTime;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25).responsive(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16)
                          .responsive(context),
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    border: Border.all(color: AppColors.indigo),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${remainingTime ?? 0}',
                    style: context.textTheme.headlineLarge
                        ?.copyWith(color: AppColors.indigo),
                  ),
                ),
                const Spacer(),
                Center(
                  child: BlocConsumer<GameCubit, GameState>(
                    listener: (context, state) {
                      if (state.sessionState == null) {
                        return;
                      }
                      if (state.sessionState!.eventType == EventType.roundEnd) {
                        if (isDialogOpened(context)) {
                          return;
                        }
                        showDialog<void>(
                          context: context,
                          builder: (context) => BlocProvider.value(
                            value: cubit,
                            child: const RoundEndDialog(),
                          ),
                        ).then((value) => pointsList.clear());
                      }
                    },
                    builder: (context, state) {
                      return GameWord(
                        hiddenAnswer: state.sessionState?.hiddenAnswer ?? '',
                        isDrawing:
                            state.uid == cubit.state.sessionState?.isDrawing,
                        theWord: state.sessionState?.correctAnswer ?? '',
                      );
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: 12.toResponsiveHeight(context),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: LeaderBoard()),
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 10,
                      color: AppColors.lightPurple,
                      surfaceTintColor: AppColors.lightPurple,
                      child: IgnorePointer(
                        ignoring: cubit.state.uid !=
                            cubit.state.sessionState?.isDrawing,
                        child: GestureDetector(
                          onPanUpdate: (details) => _handlePanUpdate(
                            context,
                            details,
                            cubit,
                          ),
                          onPanStart: (details) => _handlePanStart(
                            context,
                            details,
                            cubit,
                          ),
                          onPanEnd: (_) => _handlePanEnd(
                            cubit,
                          ),
                          child: BlocBuilder<GameCubit, GameState>(
                            builder: (context, state) {
                              final sessionState = state.sessionState;
                              if (sessionState != null) {
                                final newDrawingPoint =
                                    sessionState.points.toDrawingPoints();
                                pointsList.add(newDrawingPoint);
                              }
                              return RepaintBoundary(
                                child: CustomPaint(
                                  size: Size.infinite,
                                  painter:
                                      DrawingPainter(pointsList: pointsList),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 28.toResponsiveHeight(context),
                  ),
                  const ChatComponent(),
                ],
              ),
            ),
            SizedBox(
              height: 22.toResponsiveHeight(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePanUpdate(
    BuildContext context,
    DragUpdateDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    cubit.addPoints(
      DrawingPointsWrapper(
        points: OffsetWrapper(
          dx: globalToLocal!.dx - 27.toResponsiveWidth(context),
          dy: globalToLocal.dy - 103.toResponsiveHeight(context),
        ),
        paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
      ),
    );
  }

  void _handlePanStart(
    BuildContext context,
    DragStartDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    cubit.addPoints(
      DrawingPointsWrapper(
        points: OffsetWrapper(
          dx: globalToLocal!.dx - 27.toResponsiveWidth(context),
          dy: globalToLocal.dy - 103.toResponsiveHeight(context),
        ),
        paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
      ),
    );
  }

  void _handlePanEnd(
    GameCubit cubit,
  ) {
    cubit.addPoints(
      const DrawingPointsWrapper(
        points: null,
        paint: null,
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({
    required this.pointsList,
  });

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < pointsList.length - 1; i++) {
      final currentValue = pointsList[i];
      final nextValue = pointsList[i + 1];

      if (currentValue.isNotNull && nextValue.isNotNull) {
        canvas
          ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height))
          ..drawLine(
            currentValue.points!,
            nextValue.points!,
            currentValue.paint!,
          );
      } else if (currentValue.isNotNull && nextValue.isNull) {
        offsetPoints
          ..clear()
          ..add(currentValue.points!)
          ..add(
            Offset(
              currentValue.points!.dx + 0.1,
              currentValue.points!.dy + 0.1,
            ),
          );
        canvas
          ..drawPoints(
            PointMode.points,
            offsetPoints,
            currentValue.paint!,
          )
          ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  DrawingPoints({
    required this.points,
    required this.paint,
  });

  final Paint? paint;
  final Offset? points;

  bool get isNotNull => points != null && paint != null;

  bool get isNull => points == null || paint == null;

  @override
  String toString() {
    return '{paint: $paint, points: $points}';
  }
}

extension _DrawingPointsWrapperExtension on DrawingPointsWrapper {
  DrawingPoints toDrawingPoints() {
    final points =
        this.points != null ? Offset(this.points!.dx, this.points!.dy) : null;
    final paint = this.paint != null
        ? (Paint()
          ..isAntiAlias = this.paint!.isAntiAlias
          ..strokeWidth = this.paint!.strokeWidth)
        : null;
    return DrawingPoints(points: points, paint: paint);
  }
}
