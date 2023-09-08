import 'dart:ui';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:grappus_skribbl/views/game/view/game_word.dart';
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
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    final remainingTime =
        context.watch<GameCubit>().state.sessionState?.remainingTime;
    return Container(
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
                    // TODO: handle this case with new dialog ui
                    // if (state.sessionState == null) {
                    //   return;
                    // }
                    // if (state.sessionState!.eventType == EventType.roundEnd) {
                    //   if (isDialogOpened(context)) {
                    //     return;
                    //   }
                    //   showDialog<void>(
                    //     context: context,
                    //     builder: (context) => BlocProvider.value(
                    //       value: cubit,
                    //       child: const RoundEndDialog(),
                    //     ),
                    //   ).then((value) => pointsList.clear());
                    // }
                  },
                  builder: (context, state) {
                    return GameWord(
                      isDrawing:
                          state.uid == cubit.state.sessionState?.isDrawing,
                      theWord:
                          state.sessionState?.correctAnswer ?? 'guessing word',
                    );
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Time: ',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontSize: 32,
                        color: AppColors.pastelPink,
                        fontFamily: 'PaytoneOne',
                      ),
                    ),
                    Text(
                      '$remainingTime',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontSize: 32,
                        color: AppColors.butterCreamYellow,
                      ),
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
                ignoring:
                    cubit.state.uid != cubit.state.sessionState?.isDrawing,
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
          dy: globalToLocal.dy - 73.toResponsiveHeight(context),
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
          dy: globalToLocal.dy - 73.toResponsiveHeight(context),
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
          ..strokeWidth = this.paint!.strokeWidth
          ..color = AppColors.white)
        : null;
    return DrawingPoints(points: points, paint: paint);
  }
}
