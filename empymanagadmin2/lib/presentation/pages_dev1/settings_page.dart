import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool gpsRadiusCheck = true;
  bool remoteClockIn = true;
  bool biometricLock = true;

  final companyNameController =
  TextEditingController(text: 'Nexus Global Systems Inc.');

  final addressController = TextEditingController(
    text: '100 Innovation Way, Tech District, Suite 400',
  );

  final radiusController = TextEditingController(text: '250');
  final graceController = TextEditingController(text: '15');
  final inactivityController = TextEditingController(text: '30');

  @override
  void dispose() {
    companyNameController.dispose();
    addressController.dispose();
    radiusController.dispose();
    graceController.dispose();
    inactivityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 34, 20, 30),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1216,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildCompanyIdentity(),
                        const SizedBox(height: 24),
                        _buildGpsSection(),
                        const SizedBox(height: 24),
                        _buildWorkShiftSection(),
                        const SizedBox(height: 24),
                        _buildMobileSecuritySection(),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildSaveButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF111B32),
            Color(0xFF24205A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF354661),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF53627A),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  size: 13,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  'System Administration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Organization & Security Rules',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Configure company branch geofence radius, shift grace windows, biometric app lock requirements, and auto-session logout rules.',
            style: TextStyle(
              color: Color(0xFFE7EAF4),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPANY IDENTITY
  // ============================================================

  Widget _buildCompanyIdentity() {
    return _SettingsCard(
      title: 'Company Identity',
      icon: Icons.language,
      iconColor: const Color(0xFF5038F5),
      child: _buildTextField(
        label: 'Company Legal Name',
        controller: companyNameController,
      ),
    );
  }

  // ============================================================
  // GPS
  // ============================================================

  Widget _buildGpsSection() {
    return _SettingsCard(
      title: 'GPS Geofence & Office Radius Validation',
      icon: Icons.location_on_outlined,
      iconColor: const Color(0xFFFF1744),
      trailing: _buildCheckLabel(
        text: 'Enable GPS Radius Check',
        value: gpsRadiusCheck,
        onChanged: (value) {
          setState(() {
            gpsRadiusCheck = value;
          });
        },
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(
              children: [
                _buildTextField(
                  label: 'HQ Office Location Address',
                  controller: addressController,
                ),
                const SizedBox(height: 18),
                _buildTextField(
                  label:
                  'Allowed Clock-In Radius (Meters)',
                  controller: radiusController,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  label:
                  'HQ Office Location Address',
                  controller: addressController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label:
                  'Allowed Clock-In Radius (Meters)',
                  controller: radiusController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // WORK SHIFT
  // ============================================================

  Widget _buildWorkShiftSection() {
    return _SettingsCard(
      title:
      'Work Shift & Attendance Timing Thresholds',
      icon: Icons.access_time,
      iconColor: const Color(0xFFFF8A00),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildTimeField(
                      label:
                      'Standard Shift Start Time',
                      value: '09:00 AM',
                    ),
                    const SizedBox(height: 16),
                    _buildTimeField(
                      label:
                      'Standard Shift End Time',
                      value: '05:00 PM',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label:
                      'Late Arrival Grace Period (Minutes)',
                      controller: graceController,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTimeField(
                      label:
                      'Standard Shift Start Time',
                      value: '09:00 AM',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(
                      label:
                      'Standard Shift End Time',
                      value: '05:00 PM',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label:
                      'Late Arrival Grace Period (Minutes)',
                      controller: graceController,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: _buildCheckLabel(
              text:
              'Allow Remote / Field Employee Clock-In',
              value: remoteClockIn,
              onChanged: (value) {
                setState(() {
                  remoteClockIn = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE SECURITY
  // ============================================================

  Widget _buildMobileSecuritySection() {
    return _SettingsCard(
      title: 'Mobile Security & App Lock Policies',
      icon: Icons.lock_outline,
      iconColor: const Color(0xFF5038F5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final biometricCard = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FB),
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE8EDF4),
              ),
            ),
            child: Row(
              children: [
                _buildCheckbox(
                  value: biometricLock,
                  onChanged: (value) {
                    setState(() {
                      biometricLock = value;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enforce Biometric App Lock',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17233B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Require fingerprint/FaceID on app open',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          final logoutField = _buildTextField(
            label:
            'Inactivity Auto-Logout (Minutes)',
            controller: inactivityController,
          );

          if (constraints.maxWidth < 700) {
            return Column(
              children: [
                biometricCard,
                const SizedBox(height: 18),
                logoutField,
              ],
            );
          }

          return Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: biometricCard,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: logoutField,
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _SettingsCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        21,
        24,
        23,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.045),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: iconColor,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14213D),
                  ),
                ),
              ),
              if (trailing != null)
                trailing,
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 1,
            color: const Color(0xFFE9EDF2),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B3154),
          ),
        ),

        const SizedBox(height: 7),

        SizedBox(
          height: 39,
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF152744),
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFFD8E0EA),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFFD8E0EA),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFF5038F5),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TIME FIELD
  // ============================================================

  Widget _buildTimeField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B3154),
          ),
        ),

        const SizedBox(height: 7),

        SizedBox(
          height: 39,
          child: TextField(
            readOnly: true,
            controller:
            TextEditingController(text: value),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF152744),
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 11,
              ),
              suffixIcon: const Icon(
                Icons.access_time,
                size: 15,
                color: Colors.black,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFFD8E0EA),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFFD8E0EA),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CHECKBOX
  // ============================================================

  Widget _buildCheckLabel({
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => onChanged(!value),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckbox(
              value: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 7),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF14213D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Checkbox(
        value: value,
        onChanged: (newValue) {
          onChanged(newValue ?? false);
        },
        activeColor:
        const Color(0xFF5038F5),
        checkColor: Colors.white,
        side: const BorderSide(
          color: Color(0xFF5038F5),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(3),
        ),
        materialTapTargetSize:
        MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Admin settings saved successfully.',
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.save_outlined,
        size: 17,
      ),
      label: const Text(
        'Save & Apply Admin Settings',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
        const Color(0xFF5038F5),
        foregroundColor: Colors.white,
        elevation: 7,
        shadowColor:
        const Color(0x445038F5),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(13),
        ),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}