import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'auth/auth_manager.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthManager auth;

  @override
  void initState() {
    super.initState();
    auth = context.read<AuthManager>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/Animation - 1731791106163.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            Animate(
              effects: const [
                FadeEffect(
                    delay: Duration(seconds: 5),
                    duration: Duration(seconds: 1),
                    curve: Curves.easeIn),
              ],
              child: ElevatedButton(
                onPressed: () {
                  auth.goLogin();
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
