import 'package:flutter/material.dart';
import 'identity.dart';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] as String)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Kode: ${course['code']}'),
            Text('SKS: ${course['credits']}'),
            Text('Status: ${course['status']}'),
            const SizedBox(height: 16),
            Text(course['description'] as String),
            const Divider(height: 32),
            const Text('Mahasiswa: $studentName'),
            const Text('NIM: $studentId'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.favorite),
              label: const Text('Pilih sebagai Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
