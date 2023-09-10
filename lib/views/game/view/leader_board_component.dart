import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/models.dart';

class LeaderBoardComponent extends StatelessWidget {
  const LeaderBoardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
            l10n.leaderboardLabel,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.pastelPink,
              fontFamily: paytoneOne,
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
                  return const SizedBox.expand();
                }
                final players = sessionState.players;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final playerKey = players.keys.toList()[index];
                    return _LeaderboardListItem(
                      player: players[playerKey]!,
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
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8).responsive(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.toResponsiveHeight(context),
            height: 80.toResponsiveHeight(context),
            decoration: BoxDecoration(
              color: AppColors.backgroundBlack,
              borderRadius: BorderRadius.circular(6),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 6).copyWith(top: 10),
            child: SvgPicture.asset(
              player.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5.toResponsiveHeight(context)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12)
                  .copyWith(top: 15, bottom: 12)
                  .responsive(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        player.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Color(player.userNameColor),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${player.score} ${l10n.pointsLabel}',
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
