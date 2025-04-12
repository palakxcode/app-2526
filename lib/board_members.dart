import 'package:flutter/material.dart';
import 'widgets/board_member_tile.dart';

class BoardMembersPage extends StatelessWidget {
  final List<Map<String, String>> boardMembers = [
    {'name': 'Aditi Babu', 'position': 'Secretary'},
    {'name': ' Ayush Tripathi', 'position': 'General Secretary'},
    {'name': 'Naman Jain', 'position': 'General Secretary'},
  ];

  @override
  Widget build(BuildContext context) {
    final secretary = boardMembers
        .firstWhere((m) => m['position']!.toLowerCase() == 'secretary');

    final genSecs = boardMembers
        .where(
            (m) => m['position']!.toLowerCase().contains('general secretary'))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Board Members')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rectangular tile for Secretary
            BoardMemberTile(
              role: secretary['position']!,
              name: secretary['name']!,
              isSquare: false,
            ),
            const SizedBox(height: 24),

            // Row for the 2 Gen Secs in square tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: genSecs.map((sec) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BoardMemberTile(
                      name: sec['name']!,
                      role: sec['position']!,
                      isSquare: true,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
