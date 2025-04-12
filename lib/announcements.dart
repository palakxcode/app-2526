import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
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

          return ListView.separated(
            itemCount: announcements.length,
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              final announcement =
                  announcements[index].data() as Map<String, dynamic>;
              final message = announcement['message'] ?? 'No message content';

              // Split the message if it contains a colon, otherwise use whole message
              final parts = message.contains(':')
                  ? message.split(':')
                  : ['Announcement', message];
              final title = parts[0];
              final content = parts.length > 1 ? parts[1] : '';

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[100 + (index % 4) * 100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📢 $title",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
