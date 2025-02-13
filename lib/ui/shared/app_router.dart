import 'package:ct484_project/ui/leaderboard/leaderboard%20_screen.dart';
import 'package:go_router/go_router.dart';
import '/ui/screens.dart';

class AppRouter {
  final AuthManager authManager;

  AppRouter(this.authManager);

  late final GoRouter router = GoRouter(
    redirect: (context, state) {
      final isAuth = authManager.isAuth;
      final loggingIn = state.location == '/auth';

      if (!isAuth && !loggingIn) return '/auth';
      if (isAuth && loggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: 'quizOverview',
        path: '/quiz-overview',
        builder: (context, state) => const QuizOverviewScreen(),
      ),
      GoRoute(
        name: 'leaderBoard',
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        name: 'userProfile',
        path: '/user-profile',
        builder: (context, state) => UsersProfileScreen(authManager.user!),
      ),
    ],
  );

  GoRouter get goRouter => router;
}
