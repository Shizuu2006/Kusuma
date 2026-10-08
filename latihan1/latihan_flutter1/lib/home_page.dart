import 'package:flutter/material.dart';

import 'course_data.dart';
import 'identity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const IdentityBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang di Course Explorer',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Jelajahi ${courses.length} course, buka detail, dan tandai course favorite.',
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.school, size: 36),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tahap 15 mengintegrasikan layout responsif, navigasi, passing data, interaksi, form, dan feedback.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in courses)
                      Chip(label: Text(c['code'] as String)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
