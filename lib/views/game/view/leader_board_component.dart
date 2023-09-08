import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/models.dart';

class LeaderBoardComponent extends StatelessWidget {
  const LeaderBoardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20).copyWith(bottom: 0),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.ravenBlack,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.pastelPink,
              fontFamily: 'PaytoneOne',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.toResponsiveHeight(context)),
          Expanded(
            child: BlocBuilder<GameCubit, GameState>(
              builder: (context, state) {
                final sessionState = state.sessionState;
                if (sessionState == null) {
                  return const SizedBox();
                }
                final players = sessionState.players;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final playerKey = players.keys.toList()[index];
                    return _LeaderboardListItem(
                      player: players[playerKey]!.copyWith(
                        imagePath: Assets.avatar03,
                      ),
                      isDrawing: playerKey == state.sessionState?.isDrawing,
                    );
                  },
                  itemCount: players.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardListItem extends StatelessWidget {
  const _LeaderboardListItem({required this.player, required this.isDrawing});

  final Player player;
  final bool isDrawing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8).responsive(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundBlack,
              borderRadius: BorderRadius.circular(6),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 6).copyWith(top: 10),
            child: SvgPicture.asset(
              player.imagePath,
              width: 70.toResponsiveHeight(context),
              height: 70.toResponsiveHeight(context),
            ),
          ),
          SizedBox(width: 5.toResponsiveHeight(context)),
          Expanded(
            child: Container(
              height: 80.toResponsiveHeight(context),
              decoration: BoxDecoration(
                color: AppColors.backgroundBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.butterCreamYellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.toResponsiveHeight(context)),
                      Text(
                        '${player.score} Points',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.antiqueIvory.withOpacity(0.3),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isDrawing) ...[
                    SvgPicture.asset(Assets.pencil),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
