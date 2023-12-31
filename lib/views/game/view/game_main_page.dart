import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/views.dart';

class GameMainPage extends StatelessWidget {
  const GameMainPage({
    required this.url,
    required this.name,
    required this.selectedImagePath,
    super.key,
  });

  final String url;
  final String name;
  final String selectedImagePath;
  static const String routeName = '/game-page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepository: GameRepository(
          uri: Uri.parse(url),
        ),
      )..connect(name, selectedImagePath, generateUserNameColor()),
      child: const _GameMainPageView(),
    );
  }

  int generateUserNameColor() {
    final colorList = [
      AppColors.antiqueIvory,
      AppColors.goldenYellow,
      AppColors.goldenOrange,
      AppColors.pastelPink,
      AppColors.ceruleanBlue,
      AppColors.lavenderPurple,
      AppColors.tangerineOrange,
      AppColors.lavenderPurple,
    ];
    return colorList.randomItem().value;
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
