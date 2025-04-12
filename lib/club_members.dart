import 'package:ac_2425/board_members.dart';
import 'package:flutter/material.dart';
import 'departments.dart';
import 'widgets/custom_grid.dart';

class ClubMembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Pastel theme colors
    final pastelPink = Color(0xFFFFD1DC);
    final pastelBlue = Color(0xFFB5DEFF);
    final pastelMint = Color(0xFFAFE1AF);
    final pastelLavender = Color(0xFFE6E6FA);
    final pastelPeach = Color(0xFFFFDAB9);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Club Members",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: pastelLavender,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pastelLavender, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_alt,
                      size: 28,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Club Directory',
                      style: TextStyle(
                        fontSize: 20,
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
      ),
    );
  }
}
