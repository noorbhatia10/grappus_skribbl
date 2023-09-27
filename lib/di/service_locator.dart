import 'package:game_repository/game_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:services/services.dart';

final getIt = GetIt.instance;

Future<void> setUpServiceLocator() async {
  getIt.registerSingleton<GameRepository>(GameRepository());
}
