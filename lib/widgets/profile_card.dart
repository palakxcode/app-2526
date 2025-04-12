import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  const ProfileCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: color,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
          ),
        ),
        trailing: onTap != null
            ? Icon(Icons.arrow_forward_ios, size: 16, color: textColor)
            : null,
        onTap: onTap,
      ),
    );
  }
}
