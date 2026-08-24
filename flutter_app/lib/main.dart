import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:jobpilot_ai/app.dart';
import 'package:jobpilot_ai/core/di/injection.dart';
import 'package:jobpilot_ai/presentation/bloc/app_bloc_observer.dart';

/// The main entry point for the JobPilot AI Flutter application.
/// Initializes bindings, dependency injection, and bloc observers.
void main() async {
  // Ensure plugin services are initialized prior to configuring dependencies.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for a cleaner look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Setup the dependency injection container.
  configureDependencies();
  
  // Initialize the global Bloc observer for state change logging.
  Bloc.observer = AppBlocObserver();
  
  runApp(const JobPilotApp());
}
