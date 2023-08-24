import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/views.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156.toResponsiveHeight(context),
      width: context.screenWidth,
      child: Card(
        color: AppColors.lightPurple,
        surfaceTintColor: AppColors.lightPurple,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(14).responsive(context),
          child: BlocBuilder<GameCubit, GameState>(
            bloc: context.read<GameCubit>(),
            builder: (context, state) {
              final sessionState = state.sessionState;
              if (sessionState == null) {
                return const SizedBox();
              }
              final players = sessionState.players;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final playerKey = players.keys.toList()[index];
                  return Container(
                    padding:
                        const EdgeInsets.only(right: 14).responsive(context),
                    child: Column(
                      children: [
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              '#1 - 2023',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.midnightBlue,
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          players[playerKey]!.imagePath,
                          width: 70.toResponsiveHeight(context),
                          height: 70.toResponsiveHeight(context),
                        ),
                        SizedBox(height: 5.toResponsiveHeight(context)),
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              players[playerKey]!.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.midnightBlue,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
