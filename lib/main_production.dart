import 'package:grappus_skribbl/app/app.dart';
import 'package:grappus_skribbl/bootstrap.dart';

import 'di/service_locator.dart';

Future<void> main() async {
  await setUpServiceLocator();
  await bootstrap(() => const App());
}
