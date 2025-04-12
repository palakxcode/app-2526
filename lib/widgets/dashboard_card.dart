import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Pastel theme colors
    final pastelColors = [
      Color(0xFFFFD1DC), // Pastel Pink
      Color(0xFFB5DEFF), // Pastel Blue
      Color(0xFFAFE1AF), // Pastel Mint
      Color(0xFFE6E6FA), // Pastel Lavender
      Color(0xFFFFDAB9), // Pastel Peach
    ];

    // Randomly select a color but ensure consistency for same titles
    final colorIndex = title.length % pastelColors.length;
    final cardColor = pastelColors[colorIndex];

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor.withOpacity(0.7),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(
              _getIconForTitle(title),
              color: Colors.black54,
              size: 26,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final lowercaseTitle = title.toLowerCase();

    if (lowercaseTitle.contains('event')) return Icons.event;
    if (lowercaseTitle.contains('member')) return Icons.people;
    if (lowercaseTitle.contains('announcement')) return Icons.announcement;
    if (lowercaseTitle.contains('project')) return Icons.work;
    if (lowercaseTitle.contains('meeting')) return Icons.meeting_room;
    if (lowercaseTitle.contains('task')) return Icons.task;
    if (lowercaseTitle.contains('report')) return Icons.description;

    // Default icon
    return Icons.article;
  }
}
