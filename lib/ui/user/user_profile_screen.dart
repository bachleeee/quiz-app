import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../auth/auth_manager.dart';
import '../shared/bottom_navbar.dart';
import '../user/user_edit_screen.dart';

class UsersProfileScreen extends StatelessWidget {
  const UsersProfileScreen(
    this.user, {
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiziz'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'details') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditUserScreen(user),
                ));
              } else if (value == 'logout') {
                context.read<AuthManager>().logout();
                GoRouter.of(context).go('/auth');
              }
            },
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'details',
                child: Text(
                  'Profile Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(user.avatarUrl)),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '@${user.email.split('@')[0]}',
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  // _buildStatCard('#${user.rank}', 'World rank', Icons.stars),
                  _buildStatCard('${user.gamesPlayed}', 'Games played',
                      Icons.play_circle_fill),
                  _buildStatCard(
                      '${user.totalPoints}', 'Points total', Icons.score),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: const Color.fromARGB(255, 219, 101, 11),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
