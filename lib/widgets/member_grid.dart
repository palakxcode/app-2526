import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'custom_grid.dart';

class MemberGridPage extends StatelessWidget {
  final String department;

  const MemberGridPage({Key? key, required this.department}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$department Members'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('department', isEqualTo: department)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No members found.'));
            }

            final members = snapshot.data!.docs;

            return GridView.builder(
              itemCount: members.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final member = members[index];
                final name = member['name'] ?? 'Unnamed';

                return CustomGridCard(
                  title: name,
                  onTap: () {
                    // You can navigate to detail page if needed
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
