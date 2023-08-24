import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/app/view/chat_component/chat_component.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:models/drawing_points.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepository: GameRepository(
          uri: Uri.parse(url),
        ),
      )..connect(),
      child: _GamePage(),
    );
  }
}

class _GamePage extends StatelessWidget {
  _GamePage();

  final pointsList = <DrawingPoints>[];

  @override
  Widget build(BuildContext context) {
    final players =
        context.select((GameCubit cubit) => cubit.state.sessionState?.players);

    final newDrawingPoint = context.select((GameCubit cubit) {
      final sessionState = cubit.state.sessionState;
      if (sessionState != null) {
        final data = sessionState.points;
        final points = data.points != null
            ? Offset(data.points!.dx, data.points!.dy)
            : null;
        final paint = data.paint != null
            ? (Paint()
              ..isAntiAlias = data.paint!.isAntiAlias
              ..strokeWidth = data.paint!.strokeWidth)
            : null;
        return DrawingPoints(points: points, paint: paint);
      }
      return DrawingPoints(points: null, paint: null);
    });

    pointsList.add(newDrawingPoint);

    return Scaffold(
      body: SafeArea(
        child: players != null && players.isNotEmpty
            ? Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final renderBox =
                            context.findRenderObject() as RenderBox?;
                        final globalToLocal =
                            renderBox?.globalToLocal(details.globalPosition);
                        context.read<GameCubit>().addPoints(
                              DrawingPointsWrapper(
                                points: OffsetWrapper(
                                  dx: globalToLocal!.dx,
                                  dy: globalToLocal.dy,
                                ),
                                paint: const PaintWrapper(
                                  isAntiAlias: true,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                      },
                      onPanStart: (details) {
                        final renderBox =
                            context.findRenderObject() as RenderBox?;
                        final globalToLocal =
                            renderBox?.globalToLocal(details.globalPosition);
                        context.read<GameCubit>().addPoints(
                              DrawingPointsWrapper(
                                points: OffsetWrapper(
                                  dx: globalToLocal!.dx,
                                  dy: globalToLocal.dy,
                                ),
                                paint: const PaintWrapper(
                                  isAntiAlias: true,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                      },
                      onPanEnd: (details) {
                        context.read<GameCubit>().addPoints(
                              const DrawingPointsWrapper(
                                points: null,
                                paint: null,
                              ),
                            );
                      },
                      child: RepaintBoundary(
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: Size.infinite,
                              painter: DrawingPainter(pointsList: pointsList),
                            ),
                            Flexible(
                              child: ListView.builder(
                                itemBuilder: (context, index) => Text(
                                  players[index].userId,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                itemCount: players.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const ChatComponent(),
                ],
              )
            : const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
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
        canvas.drawLine(
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
        canvas.drawPoints(
          PointMode.points,
          offsetPoints,
          currentValue.paint!,
        );
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
