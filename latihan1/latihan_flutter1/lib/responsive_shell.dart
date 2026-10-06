import 'package:flutter/material.dart';
import 'courses_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _index = 0;
  final List<Widget> _pages = const [HomePage(), CoursesPage(), ProfilePage()];

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final expanded = c.maxWidth >= 840;
        final content = IndexedStack(index: _index, children: _pages);
        return Scaffold(
          appBar: AppBar(title: const Text('Course Explorer')),
          body: expanded
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _index,
                      onDestinationSelected: _select,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.school),
                          label: Text('Courses'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: expanded
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: _select,
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
        );
      },
    );
  }
}
