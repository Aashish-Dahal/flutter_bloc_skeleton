import 'package:flutter/material.dart';

import '../widgets/organisms/profile_details_section.dart';
import '../widgets/organisms/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Static user data based on the provided JSON
  final Map<String, dynamic> user = const {
    "id": 1,
    "username": "emilys",
    "email": "emily.johnson@x.dummyjson.com",
    "firstName": "Emily",
    "lastName": "Johnson",
    "gender": "female",
    "image": "https://dummyjson.com/icon/emilys/128"
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.35,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileHeader(user: user),
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileDetailsSection(user: user),
          ),
        ],
      ),
    );
  }
}
