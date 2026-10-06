// Demo Tahap 1,2,3,4,6,7,16. Tiap demo punya saklar "Fix" di AppBar:
// OFF = kondisi bermasalah, ON = sudah diperbaiki.
import 'package:flutter/material.dart';
import 'identity.dart';

const _id = Text('$studentId - $studentName',
    style: TextStyle(fontWeight: FontWeight.bold));
const _long =
    '$studentId - $studentName - teks sangat panjang untuk menguji overflow pada Row di layar sempit';
typedef B = Widget Function(bool fixed);

class LabPage extends StatelessWidget {
  const LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <String, B>{
      'Tahap 1 - Hard-coded 500 (Fix = Expanded)': _t1,
      'Tahap 2 - MediaQuery': _t2,
      'Tahap 3 - LayoutBuilder breakpoint': _t3,
      'Tahap 4 - Expanded & Wrap (Fix = sembunyikan Row overflow)': _t4,
      'Tahap 6 - Scroll & keyboard (Fix = SingleChildScrollView)': _t6,
      'Tahap 7 - Navigator push/pop': _t7,
      'Tahap 16A - Row overflow': _a,
      'Tahap 16B - ListView unbounded': _b,
      'Tahap 16C - Keyboard overflow': _c,
      'Tahap 16D - Navigasi ganda': (f) => _Dbl(fixed: f),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Lab')),
      body: ListView(
        children: [
          for (final e in items.entries)
            ListTile(
              title: Text(e.key),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _Case(title: e.key, builder: e.value),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Case extends StatefulWidget {
  final String title;
  final B builder;

  const _Case({required this.title, required this.builder});

  @override
  State<_Case> createState() => _CaseState();
}

class _CaseState extends State<_Case> {
  bool _fixed = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 14)),
          actions: [
            const Text('Fix'),
            Switch(value: _fixed, onChanged: (v) => setState(() => _fixed = v)),
          ],
        ),
        body: widget.builder(_fixed),
      );
}

Widget _t1(bool fixed) {
  final box = Container(
    color: Colors.amber.shade200,
    padding: const EdgeInsets.all(16),
    child: const Text('$studentId - $studentName'),
  );
  return Row(
    children: [
      fixed ? Expanded(child: box) : SizedBox(width: 500, child: box),
    ],
  );
}

Widget _t2(bool fixed) => Builder(
      builder: (context) {
        final s = MediaQuery.of(context).size;
        final o = MediaQuery.of(context).orientation;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _id,
              Text('Width: ${s.width.toStringAsFixed(0)}'),
              Text('Height: ${s.height.toStringAsFixed(0)}'),
              Text('Orientation: $o'),
              Text(
                s.width < 600 ? 'Compact' : 'Wide',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        );
      },
    );

Widget _t3(bool fixed) => LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final n = w < 600 ? 1 : (w < 840 ? 2 : 3);
        final name = ['Compact', 'Medium', 'Expanded'][n - 1];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _id,
              Text('Kategori: $name', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    for (var i = 1; i <= n; i++)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          color: Colors.blue.withOpacity(0.3),
                          alignment: Alignment.center,
                          child: Text('Panel $i'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

Widget _t4(bool fixed) {
  const skills = ['Flutter', 'Dart', 'Git', 'Firebase', 'UI Design', 'REST API', 'SQL'];
  Widget box(String t, Color c) => Container(
        height: 100,
        color: c,
        alignment: Alignment.center,
        child: Text(t),
      );
  final chips = skills.map((e) => Chip(label: Text(e))).toList();
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _id,
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(flex: 2, child: box('A (flex 2)', Colors.indigo.shade200)),
            const SizedBox(width: 8),
            Expanded(child: box('B (flex 1)', Colors.teal.shade200)),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Wrap'),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
        const SizedBox(height: 12),
        if (!fixed) ...[
          const Text('Row biasa (overflow)'),
          Row(children: chips),
        ],
      ],
    ),
  );
}

Widget _t6(bool fixed) {
  final col = Column(
    children: [
      _id,
      for (var i = 1; i <= 12; i++)
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Field $i',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
    ],
  );
  return fixed
      ? SingleChildScrollView(padding: const EdgeInsets.all(16), child: col)
      : Padding(padding: const EdgeInsets.all(16), child: col);
}

Widget _t7(bool fixed) => Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _id,
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _Detail()),
              ),
              child: const Text('Buka Detail'),
            ),
          ],
        ),
      ),
    );

class _Detail extends StatelessWidget {
  const _Detail();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _id,
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
}

Widget _a(bool fixed) => Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.info),
          const SizedBox(width: 8),
          fixed ? const Expanded(child: Text(_long)) : const Text(_long),
        ],
      ),
    );

Widget _b(bool fixed) {
  final list = ListView(
    children: List.generate(30, (i) => ListTile(title: Text('Item $i'))),
  );
  return Column(children: [_id, fixed ? Expanded(child: list) : list]);
}

Widget _c(bool fixed) {
  final form = Column(
    children: [
      Container(
        height: 500,
        color: Colors.amber.shade100,
        alignment: Alignment.center,
        child: const Text('$studentId - $studentName'),
      ),
      const Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Ketik di sini',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
  return fixed ? SingleChildScrollView(child: form) : form;
}

class _Dbl extends StatefulWidget {
  final bool fixed;

  const _Dbl({required this.fixed});

  @override
  State<_Dbl> createState() => _DblState();
}

class _DblState extends State<_Dbl> {
  bool _busy = false;

  Future<void> _open() async {
    if (widget.fixed && _busy) return; // guard anti double-tap
    _busy = true;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const _Detail()));
    _busy = false;
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ElevatedButton(
          onPressed: _open,
          child: const Text('Buka halaman'),
        ),
      );
}
