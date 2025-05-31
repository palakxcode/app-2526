import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'boards/board_dashboard.dart';
import 'core/core_dashboard.dart';
import 'member/member_dashboard.dart';
import 'club_members.dart';
import 'screens/events.dart';
import 'screens/announcements.dart';
import 'screens/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  final String role;

  DashboardScreen({required this.role});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController();
  int _pageIndex = 0;

  // Pastel theme colors
  final pastelPink = Color(0xFFFFD1DC);
  final pastelBlue = Color(0xFFB5DEFF);
  final pastelMint = Color(0xFFAFE1AF);
  final pastelLavender = Color(0xFFE6E6FA);
  final pastelPeach = Color(0xFFFFDAB9);

  final List<Widget> _memberPages = [
    MemberDashboardPage(),
    ClubMembersPage(),
    EventsPage(),
    AnnouncementsPage(),
    ProfilePage(),
  ];

  final List<Widget> _corePages = [
    CoreDashboardPage(),
    ClubMembersPage(),
    EventsPage(),
    AnnouncementsPage(),
    ProfilePage(),
  ];

  final List<Widget> _boardPages = [
    BoardDashboardPage(),
    ClubMembersPage(),
    EventsPage(),
    AnnouncementsPage(),
    ProfilePage(),
  ];

  List<Widget> get _pages {
    if (widget.role == 'Board') return _boardPages;
    if (widget.role == 'Core') return _corePages;
    return _memberPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: pastelLavender,
        showLabel: true,
        notchColor: pastelBlue,
        kBottomRadius: 28,
        kIconSize: 26.0,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home, color: Colors.black54),
            activeItem: Icon(Icons.home, color: Colors.black87),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.people, color: Colors.black54),
            activeItem: Icon(Icons.people, color: Colors.black87),
            itemLabel: 'Members',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.event, color: Colors.black54),
            activeItem: Icon(Icons.event, color: Colors.black87),
            itemLabel: 'Events',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.announcement, color: Colors.black54),
            activeItem: Icon(Icons.announcement, color: Colors.black87),
            itemLabel: 'Announcements',
          ),
          BottomBarItem(
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
