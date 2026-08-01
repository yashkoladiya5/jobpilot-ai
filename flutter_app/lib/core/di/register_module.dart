import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Module for registering third-party dependencies with Injectable.
/// This module allows Injectable to recognize and provide external packages.
@module
abstract class RegisterModule {
  /// Provides a singleton instance of FlutterSecureStorage for secure local storage.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
