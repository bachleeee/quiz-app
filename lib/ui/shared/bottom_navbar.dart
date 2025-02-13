import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentPageIndex = 0;

  final List<String> _routeNames = [
    'home',
    'quizOverview',
    'leaderBoard',
    'userProfile'
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
    context.goNamed(_routeNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;
    if (location == '/') {
      currentPageIndex = 0;
    } else if (location.startsWith('/quiz-overview')) {
      currentPageIndex = 1;
    } else if (location.startsWith('/leaderboard')) {
      currentPageIndex = 2;
    } else if (location.startsWith('/user-profile')) {
      currentPageIndex = 3;
    }

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentPageIndex,
      selectedItemColor: const Color.fromARGB(255, 21, 2, 99),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      selectedLabelStyle:
          const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      unselectedLabelStyle:
          const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
    );
  }
}
