import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Pastel theme colors
    final pastelPink = Color(0xFFFFD1DC);
    final pastelBlue = Color(0xFFB5DEFF);
    final pastelMint = Color(0xFFAFE1AF);
    final pastelLavender = Color(0xFFE6E6FA);
    final pastelPeach = Color(0xFFFFDAB9);
    final pastelYellow = Color(0xFFFFFACD);

    List<Color> pastelColors = [
      pastelPink,
      pastelBlue,
      pastelMint,
      pastelLavender,
      pastelPeach,
      pastelYellow,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [pastelLavender, Colors.white],
        ),
      ),
      padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.campaign_rounded,
                  size: 32,
                  color: Colors.black87,
                ),
                SizedBox(width: 12),
                Text(
                  'Announcements',
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('announcements').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No announcements available'));
                }

                final announcements = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement =
                        announcements[index].data() as Map<String, dynamic>;
                    final message =
                        announcement['message'] ?? 'No message content';

                    final parts = message.contains(':')
                        ? message.split(':')
                        : ['Announcement', message];
                    final title = parts[0].trim();
                    final content = parts.length > 1 ? parts[1].trim() : '';

                    final color = pastelColors[index % pastelColors.length];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.announcement_rounded,
                            color: Colors.black87,
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            content,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Optional: Handle announcement tap
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
