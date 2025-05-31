import 'package:flutter/material.dart';

class BoardMemberTile extends StatelessWidget {
  final String name;
  final String role;
  final bool isSquare;
  final String? imageUrl;

  const BoardMemberTile({
    Key? key,
    required this.name,
    required this.role,
    this.isSquare = false,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSquare ? 150 : double.infinity,
      height: isSquare ? 200 : 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageUrl != null) ...[
            CircleAvatar(
              radius: isSquare ? 40 : 25,
              backgroundImage: NetworkImage(imageUrl!),
              backgroundColor: Colors.grey[200],
              child: imageUrl == null
                  ? Icon(
                      Icons.person,
                      size: isSquare ? 40 : 25,
                      color: Colors.grey[400],
                    )
                  : null,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSquare ? 18 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: TextStyle(fontSize: isSquare ? 14 : 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
