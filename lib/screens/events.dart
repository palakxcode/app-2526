import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
    final titleController = TextEditingController();

    DateTime? selectedDateTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Event'),
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
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          selectedDateTime = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Text(selectedDateTime == null
                      ? 'Pick Date & Time'
                      : DateFormat('yMMMd – h:mm a').format(selectedDateTime!)),
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
                  if (titleController.text.isNotEmpty &&
                      selectedDateTime != null) {
                    _firestore.collection('events').add({
                      'message': '${titleController.text}',
                      'eventDate': selectedDateTime,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Post'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteEvent(String documentId) {
    _firestore.collection('events').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final pastelColors = [
      Color(0xFFFFD1DC), // pink
      Color(0xFFB5DEFF), // blue
      Color(0xFFAFE1AF), // mint
      Color(0xFFE6E6FA), // lavender
      Color(0xFFFFDAB9), // peach
      Color(0xFFFFFACD), // yellow
    ];

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6E6FA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 32),
                SizedBox(width: 12),
                Text('Events',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('events')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return Center(child: Text('No events available'));

                  final events = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final doc = events[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final id = doc.id;

                      final message = data['message'] ?? '';
                      final parts = message.split(':');
                      final title = parts[0].trim();

                      DateTime? eventDate;
                      if (data['eventDate'] != null) {
                        eventDate = (data['eventDate'] as Timestamp).toDate();
                      }

                      final color = pastelColors[index % pastelColors.length];

                      return _isPrivilegedUser
                          ? Dismissible(
                              key: Key(id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Delete Event"),
                                    content: Text(
                                        "Are you sure you want to delete this event?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text("Delete")),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) => _deleteEvent(id),
                              child: _buildEventCard(color, title, eventDate),
                            )
                          : _buildEventCard(color, title, eventDate);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: _isPrivilegedUser
          ? FloatingActionButton(
              elevation: 0,
              backgroundColor: Color(0xFFB5DEFF),
              onPressed: () => _addAnnouncement(context),
              child: Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }

  Widget _buildEventCard(Color color, String title, DateTime? date) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          if (date != null) ...[
            SizedBox(height: 8),
            Text('📅 ' + DateFormat('d MMM y – h:mm a').format(date),
                style: TextStyle(color: Colors.black87)),
          ],
        ],
      ),
    );
  }
}
