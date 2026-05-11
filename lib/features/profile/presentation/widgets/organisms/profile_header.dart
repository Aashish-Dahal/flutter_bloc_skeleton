import 'package:flutter/material.dart';

import '../atoms/profile_avatar.dart';
import '../molecules/profile_header_info.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfileHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          ProfileAvatar(
            id: user['id'],
            imageUrl: user['image'],
          ),
          const SizedBox(height: 16),
          ProfileHeaderInfo(
            firstName: user['firstName'],
            lastName: user['lastName'],
            username: user['username'],
          ),
        ],
      ),
    );
  }
}
