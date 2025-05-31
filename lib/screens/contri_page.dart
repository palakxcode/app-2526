import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContributionPage extends StatelessWidget {
  const ContributionPage({Key? key}) : super(key: key);

  Future<void> addContribution(BuildContext context, String userId) async {
    final titleController = TextEditingController();
    final pointsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Contribution"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: pointsController,
              decoration: const InputDecoration(labelText: "Points"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final points = int.tryParse(pointsController.text.trim()) ?? 0;

              if (title.isEmpty || points <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter valid title and points')),
                );
                return;
              }

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                'contribution': FieldValue.arrayUnion([
                  {
                    'title': title,
                    'points': points,
                    'date': DateTime.now(),
                  }
                ])
              });

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contribution added')),
              );
            },
            child: const Text("Submit"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contribution')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Member')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("No members found."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              final name = user['name'] ?? 'Unknown';
              final email = user['email'] ?? '';
              final userId = user.id;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(name),
                subtitle: Text(email),
                trailing: const Icon(Icons.add),
                onTap: () => addContribution(context, userId),
              );
            },
          );
        },
      ),
    );
  }
}
