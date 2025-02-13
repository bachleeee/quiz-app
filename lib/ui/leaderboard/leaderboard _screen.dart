import 'package:ct484_project/ui/leaderboard/leaderboard_list.tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../shared/bottom_navbar.dart';
import '../user/user_manager.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late Future<void> _fetchUsers;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchUsers = context.read<UserManager>().fetchUsers();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'This Week'),
            Tab(text: 'All Time'),
          ],
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.amber,
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _fetchUsers,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => context.read<UserManager>().fetchUsers(),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(context, sortBy: 'weekPoints'),
                _buildLeaderboardList(context, sortBy: 'totalPoints'),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  Widget _buildLeaderboardList(BuildContext context, {required String sortBy}) {
    return Consumer<UserManager>(
      builder: (ctx, userManager, child) {
        final users = [...userManager.users];

        users.sort((a, b) {
          if (sortBy == 'weekPoints') {
            return b.weeklyPoints.compareTo(a.weeklyPoints);
          } else {
            return b.totalPoints.compareTo(a.totalPoints);
          }
        });

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (users.isNotEmpty)
                    _buildHighlightedUser(users[0], 1, sortBy),
                  if (users.length > 1)
                    _buildHighlightedUser(users[1], 2, sortBy),
                  if (users.length > 2)
                    _buildHighlightedUser(users[2], 3, sortBy),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  final user = users[index + 3];
                  return LeaderboardListTile(user, sortBy);
                },
                childCount: users.length > 3 ? users.length - 3 : 0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightedUser(User user, int rank, String sortBy) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Points: ${sortBy == 'totalPoints' ? user.totalPoints : user.weeklyPoints}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Text(
            '#$rank',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
