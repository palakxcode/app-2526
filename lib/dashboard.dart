// dashboard_screen.dart
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'boards/board_dashboard.dart';
import 'core/core_dashboard.dart';
import 'member/member_dashboard.dart';
import 'screens/club_members.dart';
import 'screens/events.dart';
import 'screens/announcements.dart';
import 'screens/profile_page.dart';
import 'screens/contri_page.dart';

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController();
  int _pageIndex = 0;

  final pastelColors = {
    'pink': const Color(0xFFFFD1DC),
    'blue': const Color(0xFFB5DEFF),
    'mint': const Color(0xFFAFE1AF),
    'lavender': const Color(0xFFE6E6FA),
    'peach': const Color(0xFFFFDAB9),
  };

  final List<Widget> _memberPages = [
    MemberDashboardPage(),
    ClubMembersPage(),
    EventsPage(),
    AnnouncementsPage(),
    ProfilePage(),
  ];

  final List<Widget> _coreBoardPages = [
    // Shared by Core and Board
    CoreDashboardPage(),
    EventsPage(),
    AnnouncementsPage(),
    ContributionPage(),
    ProfilePage(),
  ];

  List<Widget> get _pages {
    if (widget.role == 'Board' || widget.role == 'Core') return _coreBoardPages;
    return _memberPages;
  }

  @override
  Widget build(BuildContext context) {
    final isPrivileged = widget.role == 'Board' || widget.role == 'Core';

    return Scaffold(
      body: _pages[_pageIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: pastelColors['lavender']!,
        notchColor: pastelColors['blue']!,
        kBottomRadius: 28,
        kIconSize: 26.0,
        showLabel: true,
        bottomBarItems: [
          const BottomBarItem(
            inActiveItem: Icon(Icons.home, color: Colors.black54),
            activeItem: Icon(Icons.home, color: Colors.black87),
            itemLabel: 'Home',
          ),
          if (!isPrivileged)
            const BottomBarItem(
              inActiveItem: Icon(Icons.people, color: Colors.black54),
              activeItem: Icon(Icons.people, color: Colors.black87),
              itemLabel: 'Members',
            ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.event, color: Colors.black54),
            activeItem: Icon(Icons.event, color: Colors.black87),
            itemLabel: 'Events',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.announcement, color: Colors.black54),
            activeItem: Icon(Icons.announcement, color: Colors.black87),
            itemLabel: 'Announcements',
          ),
          if (isPrivileged)
            const BottomBarItem(
              inActiveItem: Icon(Icons.stars, color: Colors.black54),
              activeItem: Icon(Icons.stars, color: Colors.black87),
              itemLabel: 'Contribute',
            ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.black54),
            activeItem: Icon(Icons.person, color: Colors.black87),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
