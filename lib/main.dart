import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'ui/shared/app_router.dart';
import 'ui/screens.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
      secondary: Colors.redAccent,
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themeData = ThemeData(
      fontFamily: 'Quicksand',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserManager()),
        ChangeNotifierProvider(create: (context) => AuthManager())
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        final appRouter = AppRouter(authManager);

        return MaterialApp.router(
          title: 'MyQuizApp',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          routerConfig: appRouter.goRouter,
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    return FutureBuilder(
                      future:
                          authManager.tryAutoLogin(), 
                      builder: (ctx, snapshot) {
                        if (authManager.isAuth) {
                          return MaterialApp.router(
                            title: 'MyQuizApp',
                            debugShowCheckedModeBanner: false,
                            theme: themeData,
                            routerConfig: appRouter.goRouter,
                          );
                        } else {
                          return const SafeArea(child: AuthScreen());
                        }
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
