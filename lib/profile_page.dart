import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryColor = Color(0xFFBFD8D2); // Soft teal
  final Color secondaryColor = Color(0xFFDCB8CB); // Soft pink
  final Color accentColor = Color(0xFFF3B8B8); // Soft coral
  final Color backgroundColor = Color(0xFFF9F9F9); // Off-white
  final Color textColor = Colors.black; // Dark text

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withOpacity(0.2), Colors.white],
          ),
        ),
        padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
        child: currentUser != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: secondaryColor),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading profile'));
                  }

                  String name = "Guest";
                  String email = currentUser.email ?? "No email available";
                  String role = "Member";

                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.exists) {
                    Map<String, dynamic> userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    name = userData['name'] ?? name;
                    email = userData['email'] ?? email;
                    role = userData['role'] ?? role;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Custom Header (replaces AppBar)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 32, color: textColor),
                              SizedBox(width: 12),
                              Text(
                                'My Profile',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: secondaryColor,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : "?",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          email,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 40),
                        ProfileCard(
                          icon: Icons.verified_user,
                          title: "User Role",
                          subtitle: role,
                          color: primaryColor,
                          textColor: textColor,
                        ),
                        SizedBox(height: 16),
                        ProfileCard(
                          icon: Icons.settings,
                          title: "Settings",
                          subtitle: "Account, Notifications, etc.",
                          color: secondaryColor,
                          textColor: textColor,
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => logout(context),
                          icon: Icon(Icons.logout, color: textColor),
                          label: Text(
                            "Log Out",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text("Not logged in"),
              ),
      ),
    );
  }
}
