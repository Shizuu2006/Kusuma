import 'package:flutter/material.dart';

const String studentName = 'I Kadek Agus Mertha Kusuma';
const String studentId = '2415051054';

/// Reusable widget #1: banner identitas
class IdentityBanner extends StatelessWidget {
  const IdentityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(12),
      child: const Text(
        '$studentId - $studentName',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
