import 'package:flutter/material.dart';
import 'package:ac_2425/board_members.dart';
import 'departments.dart';
import 'widgets/custom_grid.dart';

class ClubMembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Pastel theme colors
    final pastelPink = Color(0xFFFFD1DC);
    final pastelBlue = Color(0xFFB5DEFF);
    final pastelLavender = Color(0xFFE6E6FA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pastelLavender, Colors.white],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header instead of AppBar
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt,
                    size: 32,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Club Members',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CustomGridCard(
                    title: 'The Board',
                    description: 'Club team',
                    icon: Icons.supervisor_account,
                    color: pastelPink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BoardMembersPage(),
                        ),
                      );
                    },
                  ),
                  CustomGridCard(
                    title: 'Departments',
                    description: 'Browse by team',
                    icon: Icons.category,
                    color: pastelBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DepartmentSelectionPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
