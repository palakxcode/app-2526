import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  // Ensure user document exists in Firestore and return their role
  Future<String?> _getUserRole(User user) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'name': 'Unknown',
        'role': 'Member',
      });
      return 'Member';
    }

    final data = doc.data() as Map<String, dynamic>;
    final role = data['role'] as String?;

    if (role != null) {
      // Save role in SharedPreferences for reuse if needed
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
    }

    return role;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage(); // If user is not logged in
    }

    return FutureBuilder<String?>(
      future: _getUserRole(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Failed to load user data')),
          );
        }

        final role = snapshot.data!;
        return DashboardScreen(role: role);
      },
    );
  }
}
