import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _nameCtrl.text = prefs.getString('profile_name') ?? '';
    _phoneCtrl.text = prefs.getString('profile_phone') ?? '';
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameCtrl.text.trim());
    await prefs.setString('profile_phone', _phoneCtrl.text.trim());
    if (!mounted) return;
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 40, color: kPrimary),
            ),
          ),
          const SizedBox(height: 24),
          Text('Maglumatyňyz', style: tt.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Bu maglumat diňe lokalde (telefonda) saklanýar we bron wagtynda awtomatik doldurylýar.',
            style: tt.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Adyňyz', prefixIcon: Icon(Icons.person_outline)),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'Telefon', prefixIcon: Icon(Icons.phone_outlined), hintText: '+993...'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _save,
            child: Text(_saved ? 'Saklandy!' : 'Saklamak'),
          ),
        ],
      ),
    );
  }
}
