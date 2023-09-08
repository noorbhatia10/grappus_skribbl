import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class GameWord extends StatelessWidget {
  const GameWord({
    required this.isDrawing,
    required this.theWord,
    required this.hiddenAnswer,
    super.key,
  });

  final bool isDrawing;
  final String theWord;
  final String hiddenAnswer;
  @override
  Widget build(BuildContext context) {
    if (isDrawing) {
      return Text(
        theWord,
        style: context.textTheme.headlineMedium?.copyWith(
          color: AppColors.indigo,
        ),
      );
    }
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            hiddenAnswer.length,
            (index) => Container(
              width: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8).responsive(context),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.highEmphasisSurface,
                  ),
                ),
              ),
              child: Text(
                hiddenAnswer.split('').toList()[index],
                style: context.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.toResponsiveWidth(context)),
        Text('${theWord.length}'),
      ],
    );
  }
}
