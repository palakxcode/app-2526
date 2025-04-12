import 'package:flutter/material.dart';

class BoardMemberTile extends StatelessWidget {
  final String name;
  final String role;
  final bool isSquare;

  const BoardMemberTile({
    Key? key,
    required this.name,
    required this.role,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSquare ? 150 : double.infinity,
      height: isSquare ? 150 : 80,
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
        mainAxisAlignment:
            isSquare ? MainAxisAlignment.center : MainAxisAlignment.center,
        crossAxisAlignment:
            isSquare ? CrossAxisAlignment.center : CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
