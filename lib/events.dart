import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  final List<Map<String, dynamic>> events = List.generate(
    10,
    (index) => {
      "title": "Event ${index + 1}",
      "details": "Details for Event ${index + 1}",
      "date": "${(index % 30) + 1} ${_getMonth(index % 12)}",
      "icon": _getEventIcon(index),
    },
  );

  static String _getMonth(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  static IconData _getEventIcon(int index) {
    final icons = [
      Icons.event,
      Icons.celebration,
      Icons.groups,
      Icons.school,
      Icons.code,
      Icons.mic,
      Icons.sports_esports,
      Icons.palette,
      Icons.music_note,
      Icons.sports,
    ];
    return icons[index % icons.length];
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
                  Icons.event_note,
                  size: 32,
                  color: Colors.black87,
                ),
                SizedBox(width: 12),
                Text(
                  'Upcoming Events',
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
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
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
                  child: Row(
                    children: [
                      // Left date container
                      Container(
                        width: 70,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              event["date"].split(' ')[0],
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              event["date"].split(' ')[1],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Event details
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            event["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              event["details"],
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              event["icon"],
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            // Handle event tap
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
