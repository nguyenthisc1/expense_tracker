import '../di/injection.dart';
import 'app_seed_service.dart';

Future<void> runInitialSeed() async {
  await sl<AppSeedService>().seedIfEmpty();
}
