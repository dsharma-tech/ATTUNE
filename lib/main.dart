import 'package:attune/src/core/state/user_session.dart';
import 'package:attune/src/core/theme/app_theme.dart';
import 'package:attune/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Ensure widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return AnimatedBuilder(
      animation: UserSession.instance,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'ATTUNE',
          theme: AppTheme.getTheme(UserSession.instance.currentThemeColor),
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
