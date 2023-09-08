import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/views/views.dart';

class GameMainPage extends StatelessWidget {
  const GameMainPage({
    required this.url,
    required this.name,
    super.key,
  });

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepository: GameRepository(
          uri: Uri.parse(url),
        ),
      )..connect(name),
      child: const _GameMainPageView(),
    );
  }
}

class _GameMainPageView extends StatelessWidget {
  const _GameMainPageView();

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Column(
        children: [
          const ToolBar(),
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
