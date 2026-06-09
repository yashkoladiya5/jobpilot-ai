import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/app.dart';
import 'package:jobpilot_ai/core/di/injection.dart';
import 'package:jobpilot_ai/presentation/bloc/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(const JobPilotApp());
}
