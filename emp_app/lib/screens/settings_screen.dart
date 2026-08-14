import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.onThemeToggle});

  final VoidCallback onThemeToggle;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool push = true, email = true, biometric = false;
  String frame = 'Android', state = 'Online';

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _heading('NOTIFICATIONS'),
      PulseCard(
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: push,
              onChanged: (v) => setState(() => push = v),
              title: const Text('Push Notifications'),
              subtitle: const Text(
                'Alerts from PulseHR',
                style: TextStyle(fontSize: 11),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: email,
              onChanged: (v) => setState(() => email = v),
              title: const Text('Email Notifications'),
              subtitle: const Text(
                'Updates to your work email',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
      _heading('PREFERENCES'),
      PulseCard(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.dark_mode_outlined,
                color: AppColors.primary,
              ),
              title: const Text('App Theme'),
              subtitle: Text(
                Theme.of(context).brightness == Brightness.dark
                    ? 'Dark mode'
                    : 'Light mode',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: widget.onThemeToggle,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.language_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Language'),
              subtitle: const Text('English', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _message(
                'Language selection will be available with localization.',
              ),
            ),
          ],
        ),
      ),
      _heading('PREVIEW & APP STATES'),
      PulseCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Frame',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Android', label: Text('Android')),
                ButtonSegment(value: 'iPhone', label: Text('iPhone')),
              ],
              selected: {frame},
              onSelectionChanged: (v) => setState(() => frame = v.first),
            ),
            const SizedBox(height: 14),
            const Text(
              'Simulated App State',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: ['Online', 'Loading', 'Offline', 'Error']
                  .map(
                    (v) => ChoiceChip(
                      label: Text(v),
                      selected: state == v,
                      onSelected: (_) => setState(() => state = v),
                    ),
                  )
                  .toList(),
            ),
            if (state != 'Online')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '$state preview is selected. This frontend state is ready for service integration.',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
      ),
      _heading('SECURITY'),
      PulseCard(
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: biometric,
          onChanged: (v) => setState(() => biometric = v),
          title: const Text('Biometric Sign-in'),
          subtitle: const Text(
            'Use fingerprint or face unlock',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ),
      _heading('DEVELOPER TOOLS'),
      PulseCard(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.code, color: AppColors.primary),
              title: const Text('Flutter Implementation Notes'),
              subtitle: const Text(
                'Frontend-only mock data and local state',
                style: TextStyle(fontSize: 11),
              ),
              onTap: _showSpec,
            ),
            const Divider(),
            OutlinedButton.icon(
              onPressed: () => _message('Demo data reset successfully.'),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Demo Data'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _heading(String value) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 7),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF64748B),
      ),
    ),
  );

  void _showSpec() => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flutter Frontend Specification',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 12),
          Text(
            'All UI uses local mock data and state. Replace module repositories with API services in the next phase; screen contracts and user flows remain unchanged.',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 12),
        ],
      ),
    ),
  );
}
