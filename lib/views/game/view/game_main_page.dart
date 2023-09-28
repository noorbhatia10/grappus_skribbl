import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/di/service_locator.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/game/bloc/game_bloc.dart';
import 'package:grappus_skribbl/views/views.dart';

class GameMainPage extends StatelessWidget {
  const GameMainPage({
    required this.playerUid,
    super.key,
  });

  final String playerUid;
  static const String routeName = '/game-page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (context) => GameBloc(
        gameRepository: getIt<GameRepository>(),
      )
        ..add(const ConnectGame())
        ..add(AddPlayer(playerUid: playerUid)),
      child: const _GameMainPageView(),
    );
  }
}

class _GameMainPageView extends StatelessWidget {
  const _GameMainPageView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BaseBackground(
      child: Column(
        children: [
          ToolBar(toolBarTitle: l10n.graptoonsTitle),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 60)
                  .copyWith(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Drawing area,
                  const Expanded(
                    flex: 3,
                    child: DrawingComponent(),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: LeaderBoardComponent()),
                          Expanded(child: ChatComponent()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
