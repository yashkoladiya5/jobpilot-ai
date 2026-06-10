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
import 'package:jobpilot_ai/router/app_router.dart';
import 'package:jobpilot_ai/router/auth_guard.dart';

class JobPilotApp extends StatelessWidget {
  const JobPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authGuard = AuthGuard();
    final appRouter = AppRouter(authGuard: authGuard);

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
      ],
      child: MaterialApp.router(
        title: 'JobPilot AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.router,
      ),
    );
  }
}
