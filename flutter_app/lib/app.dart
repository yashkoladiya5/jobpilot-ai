import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/di/injection.dart';
import 'package:jobpilot_ai/core/theme/app_theme.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_bloc.dart';
import 'package:jobpilot_ai/router/app_router.dart';
import 'package:jobpilot_ai/router/auth_guard.dart';

/// The root widget of the JobPilot AI application.
/// It provides the global Bloc providers, routing, and theming.
class JobPilotApp extends StatelessWidget {
  const JobPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the authentication guard to protect private routes.
    final authGuard = AuthGuard();
    
    // Set up the application router with the auth guard.
    final appRouter = AppRouter(authGuard: authGuard);

    // Provide all the necessary BLoCs at the root of the widget tree.
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => getIt<DashboardBloc>()),
        BlocProvider<JobBloc>(create: (_) => getIt<JobBloc>()),
        BlocProvider<ResumeBloc>(create: (_) => getIt<ResumeBloc>()),
        BlocProvider<AiResumeBloc>(create: (_) => getIt<AiResumeBloc>()),
        BlocProvider<AiJobBloc>(create: (_) => getIt<AiJobBloc>()),
        BlocProvider<AiMatchBloc>(create: (_) => getIt<AiMatchBloc>()),
        BlocProvider<InterviewBloc>(create: (_) => getIt<InterviewBloc>()),
        BlocProvider<CareerInsightsBloc>(create: (_) => getIt<CareerInsightsBloc>()),
        BlocProvider<AnalyticsBloc>(create: (_) => getIt<AnalyticsBloc>()),
        BlocProvider<CoverLetterBloc>(create: (_) => getIt<CoverLetterBloc>()),
      ],
      child: MaterialApp.router(
        title: 'JobPilot AI',
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        ),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.router,
      ),
    );
  }
}
