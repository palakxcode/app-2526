import 'package:ac_2425/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoreDashboardPage extends StatefulWidget {
  @override
  _CoreDashboardPageState createState() => _CoreDashboardPageState();
}

class _CoreDashboardPageState extends State<CoreDashboardPage> {
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
            'Core dashboard – You can add stats, updates, or important notes here.',
        cardTitles: [
          'Manage Events',
          'View Members',
          'Upload Files',
          'Review Feedback'
        ],
      ),
    );
  }
}
