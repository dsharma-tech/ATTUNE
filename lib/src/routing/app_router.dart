import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attune/src/features/check_in/presentation/check_in_screen.dart';
import 'package:attune/src/features/dashboard/presentation/home_screen.dart';
import 'package:attune/src/features/tasks/presentation/tasks_screen.dart';
import 'package:attune/src/features/focus/presentation/focus_screen.dart';
import 'package:attune/src/features/settings/presentation/settings_screen.dart';
import 'package:attune/src/features/settings/presentation/profile_screen.dart';
import 'package:attune/src/features/settings/presentation/notification_settings_screen.dart';
import 'package:attune/src/features/settings/presentation/focus_settings_screen.dart';
import 'package:attune/src/features/timeline/presentation/timeline_screen.dart';
import 'scaffold_with_nav_bar.dart';

import 'package:attune/src/features/onboarding/presentation/onboarding_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/focus',
                builder: (context, state) => const FocusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timeline',
                builder: (context, state) => const TimelineScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'focus',
                    builder: (context, state) => const FocusSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
