import 'dart:ui';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:grappus_skribbl/views/game/view/game_word.dart';
import 'package:grappus_skribbl/views/result/view/result_page.dart';
import 'package:models/models.dart';

class DrawingComponent extends StatefulWidget {
  const DrawingComponent({super.key});

  @override
  State<DrawingComponent> createState() => _DrawingComponentState();
}

class _DrawingComponentState extends State<DrawingComponent> {
  late List<DrawingPoints> pointsList = <DrawingPoints>[];

  bool isDialogOpened(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  bool isStartDialogueVisited = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    final l10n = context.l10n;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.ravenBlack,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocConsumer<GameCubit, GameState>(
                      listener: (context, state) {
                        if (state.eventType == EventType.gameEnd) {
                          final leaderBoard = state.leaderboard;
                          context.read<GameCubit>()
                            ..endGame()
                            ..close();
                          context.pushReplacement(
                            ResultPage(
                              leaderBoard: leaderBoard ?? [],
                            ),
                          );
                        }
                        if (state.eventType == EventType.roundStart &&
                            !isStartDialogueVisited) {
                          if (!isDialogOpened(context)) {
                            GameDialog.show(
                              context,
                              title: state.currentDrawingPlayerId ==
                                      state.currentPlayerUid
                                  ? l10n.itsYourTurnLabel
                                  : '${state.players![state.currentDrawingPlayerId]?.name} is drawing',
                              subtitle: state.currentDrawingPlayerId !=
                                      state.currentPlayerUid
                                  ? 'Try to guess the word'
                                  : l10n.wordToDrawLabel,
                              body: state.currentDrawingPlayerId !=
                                      state.currentPlayerUid
                                  ? 'Good luck mate!!'
                                  : state.correctAnswer ??
                                      l10n.wordLoadingLabel,
                            ).then((value) {
                              isStartDialogueVisited = true;
                            });
                          }
                        }
                        if (state.eventType == EventType.roundEnd) {
                          if (isDialogOpened(context)) {
                            return;
                          }
                          GameDialog.show(
                            context,
                            title: (state.remainingTime ?? 0) > 0
                                ? 'Everybody guessed the correct word'
                                : l10n.timesUpLabel,
                            body: state.correctAnswer ?? l10n.wordLoadingLabel,
                            subtitle: l10n.theAnswerWasLabel,
                          ).then((value) {
                            pointsList.clear();
                            isStartDialogueVisited = false;
                          });
                        }
                      },
                      builder: (context, state) {
                        return GameWord(
                          isDrawing: state.currentPlayerUid ==
                              cubit.state.currentDrawingPlayerId,
                          theWord: state.correctAnswer ?? l10n.wordLoadingLabel,
                          hiddenAnswer: state.hiddenAnswer ?? '',
                        );
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          l10n.timeLabel,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontSize: 32,
                            color: AppColors.pastelPink,
                            fontFamily: paytoneOne,
                          ),
                        ),
                        BlocBuilder<GameCubit, GameState>(
                          buildWhen: (prev, curr) =>
                              prev.remainingTime != curr.remainingTime,
                          builder: (context, state) {
                            return Text(
                              '${state.remainingTime ?? 0}',
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 32,
                                color: AppColors.butterCreamYellow,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  color: AppColors.backgroundBlack,
                  surfaceTintColor: AppColors.white,
                  child: IgnorePointer(
                    ignoring: cubit.state.currentPlayerUid !=
                        cubit.state.currentDrawingPlayerId,
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
                        buildWhen: (prev, curr) =>
                            prev.drawingPoints != curr.drawingPoints,
                        builder: (context, state) {
                          final drawingPoints = state.drawingPoints;
                          if (drawingPoints != null &&
                              state.currentDrawingPlayerId !=
                                  state.currentPlayerUid) {
                            final newDrawingPoint =
                                drawingPoints.toDrawingPoints();
                            pointsList.add(newDrawingPoint);
                          }
                          return RepaintBoundary(
                            child: pointsList.isEmpty
                                ? const SizedBox()
                                : CustomPaint(
                                    size: Size.infinite,
                                    painter:
                                        DrawingPainter(pointsList: pointsList),
                                    // painter: DrawingPainter(points: pointsList.last),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePanUpdate(
    BuildContext context,
    DragUpdateDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    final drawingPoints = DrawingPointsWrapper(
      points: OffsetWrapper(
        dx: globalToLocal!.dx - 27.toResponsiveWidth(context),
        dy: globalToLocal.dy - 73.toResponsiveHeight(context),
      ),
      paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
    );
    if (cubit.state.currentDrawingPlayerId == cubit.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    cubit.addPoints(
      drawingPoints,
    );
  }

  void _handlePanStart(
    BuildContext context,
    DragStartDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    final drawingPoints = DrawingPointsWrapper(
      points: OffsetWrapper(
        dx: globalToLocal!.dx - 27.toResponsiveWidth(context),
        dy: globalToLocal.dy - 73.toResponsiveHeight(context),
      ),
      paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
    );
    if (cubit.state.currentDrawingPlayerId == cubit.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    cubit.addPoints(
      drawingPoints,
    );
  }

  void _handlePanEnd(
    GameCubit cubit,
  ) {
    const drawingPoints = DrawingPointsWrapper(
      points: null,
      paint: null,
    );
    if (cubit.state.currentDrawingPlayerId == cubit.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    cubit.addPoints(
      drawingPoints,
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
          ..strokeWidth = this.paint!.strokeWidth
          ..color = AppColors.white)
        : null;
    return DrawingPoints(points: points, paint: paint);
  }
}
