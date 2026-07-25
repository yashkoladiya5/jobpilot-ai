import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

/// Global instance of GetIt for dependency injection.
final getIt = GetIt.instance;

/// Configures and initializes all generated dependencies.
@InjectableInit()
void configureDependencies() => getIt.init();
