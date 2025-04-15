import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPrivilegedUser = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          String role = userDoc.get('role');
          setState(() {
            _isPrivilegedUser = (role == 'Core' || role == 'Board');
          });
        }
      }
    } catch (e) {
      print('Error checking user role: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addAnnouncement(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                _firestore.collection('announcements').add({
                  'message':
                      '${titleController.text}: ${contentController.text}',
                  // 'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  void _deleteAnnouncement(String documentId) {
    _firestore.collection('announcements').doc(documentId).delete();
  }

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

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
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
                stream: _firestore
                    .collection('announcements')
                    // .orderBy('timestamp', descending: true)
                    .snapshots(),
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
                      final announcementDoc = announcements[index];
                      final announcement =
                          announcementDoc.data() as Map<String, dynamic>;
                      final documentId = announcementDoc.id;
                      final message =
                          announcement['message'] ?? 'No message content';

                      final parts = message.contains(':')
                          ? message.split(':')
                          : [message];
                      final title = parts[0].trim();
                      final content = parts.length > 1 ? parts[1].trim() : '';

                      final color = pastelColors[index % pastelColors.length];

                      // If user is privileged, wrap with Dismissible for swipe-to-delete
                      return _isPrivilegedUser
                          ? Dismissible(
                              key: Key(documentId),
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text(
                                          "Are you sure you want to delete this announcement?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                _deleteAnnouncement(documentId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Announcement deleted')));
                              },
                              child:
                                  _buildAnnouncementCard(color, title, content),
                            )
                          : _buildAnnouncementCard(color, title, content);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Add floating action button only for privileged users
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: _isPrivilegedUser
          ? FloatingActionButton(
              elevation: 0,
              backgroundColor: pastelBlue,
              child: Icon(Icons.add, color: Colors.black87),
              onPressed: () => _addAnnouncement(context),
            )
          : null,
    );
  }

  Widget _buildAnnouncementCard(Color color, String title, String content) {
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
    );
  }
}
