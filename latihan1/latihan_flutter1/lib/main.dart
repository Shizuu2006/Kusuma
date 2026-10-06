import 'package:flutter/material.dart';

import 'lab.dart';
import 'responsive_shell.dart';

const bool useLab = false;

void main() => runApp(const CourseExplorerApp());

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: useLab ? const LabPage() : const ResponsiveShell(),
    );
  }
}
