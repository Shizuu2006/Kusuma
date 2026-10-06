import 'package:flutter/material.dart';

import 'course_card.dart';
import 'course_data.dart';
import 'identity.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  int _columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  Future<void> _openDetail(
      BuildContext context, Map<String, dynamic> course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${course['title']} dipilih sebagai favorite')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const IdentityBanner(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columnsFor(constraints.maxWidth),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 150,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    course: course,
                    onTap: () => _openDetail(context, course),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}