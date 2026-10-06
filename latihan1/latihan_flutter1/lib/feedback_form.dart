import 'package:flutter/material.dart';
import 'identity.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: studentName);
  final _nimCtrl = TextEditingController(text: studentId);
  final _commentCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kirim feedback sekarang?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Kirim')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _loading = false;
      _result = '${_nameCtrl.text} (${_nimCtrl.text}): ${_commentCtrl.text.trim()}';
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
            validator: (v) => _required(v, 'Nama'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nimCtrl,
            decoration: const InputDecoration(
              labelText: 'NIM',
              border: OutlineInputBorder(),
            ),
            validator: (v) => _required(v, 'NIM'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _commentCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().length < 5) ? 'Komentar minimal 5 karakter' : null,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Kirim Feedback'),
          ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Feedback diterima:\n$_result'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
