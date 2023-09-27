import 'dart:ui';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/di/service_locator.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/canvas/bloc/canvas_bloc.dart';
import 'package:grappus_skribbl/views/game/bloc/game_bloc.dart';
import 'package:grappus_skribbl/views/game/view/game_word.dart';
import 'package:grappus_skribbl/views/result/view/result_page.dart';
import 'package:models/models.dart';

class DrawingComponent extends StatelessWidget {
  const DrawingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanvasBloc>(
      create: (context) => CanvasBloc(gameRepository: getIt<GameRepository>())
        ..add(const ConnectPointsStream()),
      child: const DrawingComponentView(),
    );
  }
}

class DrawingComponentView extends StatefulWidget {
  const DrawingComponentView({super.key});

  @override
  State<DrawingComponentView> createState() => _DrawingComponentViewState();
}

class _DrawingComponentViewState extends State<DrawingComponentView> {
  late List<DrawingPoints> pointsList = <DrawingPoints>[];

  bool isDialogOpened(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  bool isStartDialogueVisited = false;

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    final canvasBloc = context.read<CanvasBloc>();
    // final remainingTime =
    //     context.watch<GameCubit>().state.sessionState?.remainingTime;
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
                    BlocConsumer<GameBloc, GameState>(
                      listener: (context, state) {
                        if (state.eventType == EventType.gameEnd) {
                          final leaderBoard = state.players;
                          // context.read<GameBloc>()
                          //   ..endGame()
                          //   ..close();
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
                              title: state.currentDrawingPlayerUid ==
                                      state.currentPlayerUid
                                  ? l10n.itsYourTurnLabel
                                  : '${state.players.firstWhere((player) => player.isDrawing).name} is drawing',
                              subtitle: state.currentDrawingPlayerUid !=
                                      state.currentPlayerUid
                                  ? 'Try to guess the word'
                                  : l10n.wordToDrawLabel,
                              body: state.currentDrawingPlayerUid !=
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
                            title: state.remainingTime > 0
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
                              state.currentDrawingPlayerUid,
                          theWord: state.correctAnswer == ''
                              ? l10n.wordLoadingLabel
                              : state.correctAnswer,
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
                        BlocBuilder<GameBloc, GameState>(
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
                    ignoring: gameBloc.state.currentPlayerUid !=
                        gameBloc.state.currentDrawingPlayerUid,
                    child: GestureDetector(
                      onPanUpdate: (details) => _handlePanUpdate(
                        context,
                        details,
                        canvasBloc,
                        gameBloc,
                      ),
                      onPanStart: (details) => _handlePanStart(
                        context,
                        details,
                        canvasBloc,
                        gameBloc,
                      ),
                      onPanEnd: (_) => _handlePanEnd(
                        canvasBloc,
                        gameBloc,
                      ),
                      child: BlocBuilder<CanvasBloc, CanvasState>(
                        buildWhen: (prev, curr) =>
                            prev.drawingPointsWrapper !=
                            curr.drawingPointsWrapper,
                        builder: (context, state) {
                          if (gameBloc.state.currentDrawingPlayerUid !=
                              gameBloc.state.currentPlayerUid) {
                            final newDrawingPoint =
                                state.drawingPointsWrapper.toDrawingPoints();
                            pointsList.add(newDrawingPoint);
                          }
                          return RepaintBoundary(
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: DrawingPainter(pointsList: pointsList),
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
    CanvasBloc canvasBloc,
    GameBloc gameBloc,
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
    if (gameBloc.state.currentDrawingPlayerUid ==
        gameBloc.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    canvasBloc.add(AddPointsToServer(drawingPointsWrapper: drawingPoints));
    // cubit.addPoints(
    //   drawingPoints,
    // );
  }

  void _handlePanStart(
    BuildContext context,
    DragStartDetails details,
    CanvasBloc canvasBloc,
    GameBloc gameBloc,
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
    if (gameBloc.state.currentDrawingPlayerUid ==
        gameBloc.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    canvasBloc.add(AddPointsToServer(drawingPointsWrapper: drawingPoints));
    // cubit.addPoints(
    //   drawingPoints,
    // );
  }

  void _handlePanEnd(
    CanvasBloc canvasBloc,
    GameBloc gameBloc,
  ) {
    const drawingPoints = DrawingPointsWrapper(
      points: null,
      paint: null,
    );
    if (gameBloc.state.currentDrawingPlayerUid ==
        gameBloc.state.currentPlayerUid) {
      pointsList.add(drawingPoints.toDrawingPoints());
    }
    canvasBloc
        .add(const AddPointsToServer(drawingPointsWrapper: drawingPoints));
    // cubit.addPoints(
    //   drawingPoints,
    // );
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
