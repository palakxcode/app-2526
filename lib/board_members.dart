import 'package:flutter/material.dart';
import 'widgets/board_member_tile.dart';
import 'models/club_member.dart';

class BoardMembersPage extends StatelessWidget {
  final List<ClubMember> boardMembers = [
    ClubMember(
      name: 'Aditi Babu',
      position: 'Secretary',
      imageUrl: 'https://example.com/placeholder.jpg', // Replace with actual image URL
    ),
    ClubMember(
      name: 'Aayush Tripathi',
      position: 'General Secretary',
      imageUrl: 'https://example.com/placeholder.jpg', // Replace with actual image URL
    ),
    ClubMember(
      name: 'Naman Jain',
      position: 'General Secretary',
      imageUrl: 'https://example.com/placeholder.jpg', // Replace with actual image URL
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final secretary = boardMembers
        .firstWhere((m) => m.position.toLowerCase() == 'secretary');

    final genSecs = boardMembers
        .where((m) => m.position.toLowerCase().contains('general secretary'))
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
              role: secretary.position,
              name: secretary.name,
              imageUrl: secretary.imageUrl,
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
                      name: sec.name,
                      role: sec.position,
                      imageUrl: sec.imageUrl,
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
