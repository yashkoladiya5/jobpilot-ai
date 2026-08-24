import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dart:developer' as developer;
import 'injection.config.dart';

/// Global instance of GetIt for dependency injection.
final getIt = GetIt.instance;

/// Configures and initializes all generated dependencies.
/// This must be called before the app starts to ensure all services are ready.
@InjectableInit()
void configureDependencies() {
  developer.log('Initializing Dependency Injection...', name: 'GetIt');
  getIt.init();
  developer.log('Dependency Injection initialized successfully.', name: 'GetIt');
}
