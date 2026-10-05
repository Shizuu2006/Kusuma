import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Kadek Agus Mertha Kusuma';
const String studentId = '2415051054';

// Data Collection - List of Topics
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {'title': 'Flutter UI Fundamentals', 'subtitle': 'Widgets & layout', 'done': false},
  {'title': '$studentId - $studentName', 'subtitle': 'Pemilik aplikasi', 'done': false},
];

// Fungsi untuk membaca JSON dari assets
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}


void main() {
  runApp(const MyApp());
}

// Fungsi Reusable Widget untuk Stat Card
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// StatefulWidget untuk Input & State
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$studentId - $studentName'),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Masukkan pesan Anda',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        const SizedBox(height: 12),
        Text(message),
      ],
    );
  }
}

// StatefulWidget untuk Dashboard Page dengan FutureBuilder
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData(); // Inisialisasi future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: studentFuture,
            builder: (context, snapshot) {
              // State: Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // State: Error
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat data: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              // State: Success (Data loaded)
              final data = snapshot.data!;
              final student = data['student'] as Map<String, dynamic>;
              final courses = data['courses'] as List<dynamic>;

              return Column(
                children: [
                  // Profile / Identity Card
                  Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundImage: const AssetImage('assets/images/profile.jpg'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            student['name'] as String,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(student['nim'] as String),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.school),
                              SizedBox(width: 8),
                              Text('Mobile Programming Student'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Summary Row dengan Stat Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        buildStatCard('${courses.length}', 'Courses', Icons.school),
                        buildStatCard(
                          '${courses.where((c) => (c as Map)['status'] == 'done').length}',
                          'Done',
                          Icons.check_circle,
                        ),
                        buildStatCard(
                          '${courses.where((c) => (c as Map)['status'] == 'active').length}',
                          'Active',
                          Icons.schedule,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Debugging: RenderFlex Overflow Example
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '⚙️ Debugging Tips',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Fix RenderFlex Overflow:',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '$studentId - $studentName - Ini adalah teks yang sangat panjang untuk menguji layout. Teks ini dibungkus dengan Expanded agar tidak overflow.',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Courses',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${courses.length} total',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Expanded ListView untuk Courses
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        final isDone = course['status'] == 'done';
                        final isActive = course['status'] == 'active';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: isDone ? 2 : 4,
                          child: ListTile(
                            leading: Icon(
                              isDone
                                  ? Icons.check_circle
                                  : isActive
                                      ? Icons.schedule
                                      : Icons.circle_outlined,
                              color: isDone
                                  ? Colors.green
                                  : isActive
                                      ? Colors.orange
                                      : Colors.grey,
                            ),
                            title: Text(
                              course['title'] as String,
                              style: TextStyle(
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text('${course['code']} • ${course['credits']} credits'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDone
                                    ? Colors.green
                                    : isActive
                                        ? Colors.orange
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isDone
                                    ? 'Done'
                                    : isActive
                                        ? 'Active'
                                        : 'Pending',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}