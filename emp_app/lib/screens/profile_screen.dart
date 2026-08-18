import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onSignOut,
  });

  final VoidCallback onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.danger,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              _error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadUser();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_user == null) {
      return const Center(
        child: Text('User profile not found'),
      );
    }

    final user = _user!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --------------------------------------------------
        // PROFILE HEADER
        // --------------------------------------------------
        Center(
          child: Column(
            children: [
              _buildAvatar(user),
              const SizedBox(height: 9),

              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              Text(
                user.designation,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                user.employeeId,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // --------------------------------------------------
        // PERSONAL INFORMATION
        // --------------------------------------------------
        _section(
          'PERSONAL INFORMATION',
          [
            ['Email', user.email],
            ['Phone', user.phone ?? '-'],
            ['Date of Birth', user.dob ?? '-'],
            ['Address', user.address ?? '-'],
          ],
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------
        // EMPLOYMENT DETAILS
        // --------------------------------------------------
        _section(
          'EMPLOYMENT DETAILS',
          [
            ['Department', user.department],
            ['Joining Date', user.joiningDate],
            ['Employment Type', user.employmentType],
            ['Manager', user.managerName ?? '-'],
          ],
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------
        // EMERGENCY CONTACT
        // --------------------------------------------------
        PulseCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.contact_emergency_outlined,
              color: AppColors.primary,
            ),
            title: const Text(
              'Emergency Contact',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              user.emergencyContact != null
                  ? '${user.emergencyContact!.name} · '
                  '${user.emergencyContact!.phone}'
                  : 'No emergency contact added',
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
            trailing: const Icon(
              Icons.edit_outlined,
            ),
            onTap: _editEmergency,
          ),
        ),

        const SizedBox(height: 15),

        // --------------------------------------------------
        // EDIT PROFILE
        // --------------------------------------------------
        PrimaryButton(
          label: 'Edit Profile',
          icon: Icons.edit_outlined,
          onPressed: _edit,
        ),

        const SizedBox(height: 10),

        // --------------------------------------------------
        // SIGN OUT
        // --------------------------------------------------
        OutlinedButton.icon(
          onPressed: widget.onSignOut,
          icon: const Icon(
            Icons.logout,
            color: AppColors.danger,
          ),
          label: const Text(
            'Sign Out Account',
            style: TextStyle(
              color: AppColors.danger,
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================
  // AVATAR
  // ======================================================

  Widget _buildAvatar(UserModel user) {
    if (user.avatar.isNotEmpty) {
      return CircleAvatar(
        radius: 42,
        backgroundColor: AppColors.primary,
        backgroundImage: NetworkImage(user.avatar),
      );
    }

    return CircleAvatar(
      radius: 42,
      backgroundColor: AppColors.primary,
      child: Text(
        _getInitials(user.name),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // ======================================================
  // SECTION
  // ======================================================

  Widget _section(
      String title,
      List<List<String>> rows,
      ) {
    return PulseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          ...rows.map(
                (row) => ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                row[0],
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
              trailing: Text(
                row[1],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // EDIT PROFILE
  // ======================================================

  void _edit() {
    final user = _user;

    if (user == null) return;

    final nameController = TextEditingController(
      text: user.name,
    );

    final phoneController = TextEditingController(
      text: user.phone ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(c).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),

            const SizedBox(height: 14),

            PrimaryButton(
              label: 'Save Changes',
              icon: Icons.save,
              onPressed: () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                try {
                  await _userService.submitProfileUpdateRequest(
                    name: name,
                    phone: phone,
                  );

                  await _loadUser();

                  if (c.mounted) {
                    Navigator.pop(c);
                  }
                } catch (e) {
                  if (!c.mounted) return;

                  ScaffoldMessenger.of(c).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to update profile: $e',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // EDIT EMERGENCY CONTACT
  // ======================================================

  void _editEmergency() {
    final user = _user;

    if (user == null) return;

    final emergency = user.emergencyContact;

    final nameController = TextEditingController(
      text: emergency?.name ?? '',
    );

    final relationshipController = TextEditingController(
      text: emergency?.relationship ?? '',
    );

    final phoneController = TextEditingController(
      text: emergency?.phone ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(c).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Emergency Contact',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Contact name',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: relationshipController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),

            const SizedBox(height: 14),

            PrimaryButton(
              label: 'Save Contact',
              icon: Icons.save,
              onPressed: () async {
                final name = nameController.text.trim();
                final relationship =
                relationshipController.text.trim();
                final phone = phoneController.text.trim();

                if (name.isEmpty ||
                    relationship.isEmpty ||
                    phone.isEmpty) {
                  return;
                }

                try {
                  await _userService.submitProfileUpdateRequest(
                    name: name,
                    phone: phone,
                  );

                  await _loadUser();

                  if (c.mounted) {
                    Navigator.pop(c);
                  }
                } catch (e) {
                  if (!c.mounted) return;

                  ScaffoldMessenger.of(c).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to update contact: $e',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}