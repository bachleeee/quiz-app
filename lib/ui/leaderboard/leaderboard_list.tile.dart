import 'package:flutter/material.dart';

import '../../models/user.dart';

class LeaderboardListTile extends StatelessWidget {
  final User user;
  final String sortby;

  const LeaderboardListTile(
    this.user,
    this.sortby, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      trailing: Text(
        sortby == 'totalPoints'
            ? '${user.totalPoints}'
            : '${user.weeklyPoints}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }
}
