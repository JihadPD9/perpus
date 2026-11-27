import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../routes/app_routing.dart';
import '../services/auth_service.dart';

class ProfileAboutPage extends StatefulWidget {
  const ProfileAboutPage({super.key});

  @override
  State<ProfileAboutPage> createState() => _ProfileAboutPageState();
}

class _ProfileAboutPageState extends State<ProfileAboutPage> {
  late Future<UserModel> _user;
  bool _isLoggingOut = false;

  static const String _className = 'XII RPL 1';

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser();
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await AuthService.logout();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesi lokal dihapus; logout server gagal: $error'),
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouting.login, (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Gagal memuat profil: ${snapshot.error}'),
                TextButton(
                  onPressed: () =>
                      setState(() => _user = AuthService.currentUser()),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        final user = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 20),
            _ProfileField(label: 'Nama', value: user.name),
            _ProfileField(label: 'Email akun', value: user.email),
            const _ProfileField(label: 'Kelas', value: _className),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isLoggingOut ? null : _logout,
              icon: const Icon(Icons.logout),
              label: Text(_isLoggingOut ? 'Memproses...' : 'Logout'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label, style: Theme.of(context).textTheme.labelLarge),
        subtitle: SelectableText(value),
      ),
    );
  }
}
