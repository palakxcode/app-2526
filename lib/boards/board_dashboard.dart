import 'package:ac_2425/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoardDashboardPage extends StatefulWidget {
  @override
  _BoardDashboardPageState createState() => _BoardDashboardPageState();
}

class _BoardDashboardPageState extends State<BoardDashboardPage> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userData['name'] ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardLayout(
        userName: userName,
        description:
            'Welcome to the Board Dashboard. You can manage tasks, oversee reports, and connect with members.',
        cardTitles: [
          'Assign Tasks',
          'Review Reports',
          'Member List',
          'Send Notices',
        ],
      ),
    );
  }
}
