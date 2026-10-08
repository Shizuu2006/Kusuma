import 'package:flutter/material.dart';

import 'course_card.dart';
import 'course_data.dart';
import 'course_detail_page.dart';
import 'identity.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final Set<String> _favorites = {};
  late final TextEditingController _searchCtrl;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredCourses() {
    if (_searchQuery.isEmpty) {
      return courses;
    }
    final query = _searchQuery.toLowerCase();
    return courses
        .where((course) =>
            (course['title'] as String).toLowerCase().contains(query) ||
            (course['code'] as String).toLowerCase().contains(query))
        .toList();
  }

  int _columnsFor(double width) {
    if (width < 840) return 2;
    return 3;
  }

  void _toggleFavorite(Map<String, dynamic> course) {
    final code = course['code'] as String;
    final title = course['title'] as String;
    late final bool added;

    setState(() {
      if (_favorites.remove(code)) {
        added = false;
      } else {
        _favorites.add(code);
        added = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? '$title ditambahkan ke favorite'
              : '$title dihapus dari favorite',
        ),
      ),
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    Map<String, dynamic> course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
    if (result == true && context.mounted) {
      setState(() => _favorites.add(course['code'] as String));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${course['title']} dipilih sebagai favorite')),
      );
    }
  }

  void _showInfo(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(course['description'] as String),
            const SizedBox(height: 8),
            const Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    final code = course['code'] as String;

    return CourseCard(
      course: course,
      isFavorite: _favorites.contains(code),
      onTap: () => _openDetail(context, course),
      onLongPress: () => _showInfo(course),
      onFavoriteTap: () => _toggleFavorite(course),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _getFilteredCourses();
    
    return Column(
      children: [
        const IdentityBanner(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (filteredCourses.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada course yang sesuai',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              if (constraints.maxWidth < 600) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCourses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCourseItem(filteredCourses[index]);
                  },
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columnsFor(constraints.maxWidth),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 156,
                ),
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  return _buildCourseItem(filteredCourses[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
