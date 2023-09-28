import 'package:game_repository/game_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setUpServiceLocator() async {
  getIt.registerSingleton<GameRepository>(
    GameRepository(url: 'ws://localhost:8080/ws'),
  );
}
