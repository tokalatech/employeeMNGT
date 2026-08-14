import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('System Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive email alerts for pending requests'),
          value: true,
          onChanged: (val) {},
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Dark Mode Preference'),
          subtitle: const Text('Toggle dark theme layout'),
          value: false,
          onChanged: (val) {},
        ),
      ],
    );
  }
}