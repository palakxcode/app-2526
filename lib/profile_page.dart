import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pastel color palette
  final Color primaryColor = Color(0xFFBFD8D2); // Soft teal
  final Color secondaryColor = Color(0xFFDCB8CB); // Soft pink
  final Color accentColor = Color(0xFFF3B8B8); // Soft coral
  final Color backgroundColor = Color(0xFFF9F9F9); // Off-white
  final Color textColor = Color(0xFF5C5C5C); // Soft dark gray

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Get current user
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(24),
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

                  // Get user data
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
                            color: textColor.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 40),
                        ProfileCard(
                          icon: Icons.verified_user,
                          title: "User Role",
                          subtitle: role,
                          color: primaryColor.withOpacity(0.7),
                          textColor: textColor,
                        ),
                        SizedBox(height: 16),
                        ProfileCard(
                          icon: Icons.settings,
                          title: "Settings",
                          subtitle: "Account, Notifications, etc.",
                          color: secondaryColor.withOpacity(0.7),
                          textColor: textColor,
                          onTap: () {
                            // Navigate to settings
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
