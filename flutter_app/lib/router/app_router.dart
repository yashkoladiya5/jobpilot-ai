import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/pages/dashboard/dashboard_screen.dart';
import 'package:jobpilot_ai/presentation/pages/jobs/add_job_screen.dart';
import 'package:jobpilot_ai/presentation/pages/jobs/edit_job_screen.dart';
import 'package:jobpilot_ai/presentation/pages/jobs/job_detail_screen.dart';
import 'package:jobpilot_ai/presentation/pages/jobs/jobs_list_screen.dart';
import 'package:jobpilot_ai/presentation/pages/login/login_screen.dart';
import 'package:jobpilot_ai/presentation/pages/register/register_screen.dart';
import 'package:jobpilot_ai/presentation/pages/resume/resume_screen.dart';
import 'package:jobpilot_ai/presentation/pages/splash/splash_screen.dart';
import 'package:jobpilot_ai/router/auth_guard.dart';

class AppRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  late final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    redirect: (context, state) => authGuard.guard(context, state),
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.dashboardRoute,
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.jobsRoute,
                name: 'jobs',
                builder: (context, state) => const JobsListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'jobCreate',
                    builder: (context, state) => const AddJobScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'jobDetail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return JobDetailScreen(jobId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: 'jobEdit',
                        builder: (context, state) {
                          return EditJobScreen(
                            job: state.extra as JobApplication,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.resumesRoute,
                name: 'resumes',
                builder: (context, state) => const ResumeScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Resumes',
          ),
        ],
      ),
    );
  }
}
