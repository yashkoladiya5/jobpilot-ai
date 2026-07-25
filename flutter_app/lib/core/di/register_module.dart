import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Module for registering third-party dependencies with Injectable.
@module
abstract class RegisterModule {
  /// Provides a singleton instance of FlutterSecureStorage for secure local storage.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
