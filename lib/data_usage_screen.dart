import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataUsageScreen extends StatefulWidget {
  const DataUsageScreen({super.key});

  @override
  State<DataUsageScreen> createState() => _DataUsageScreenState();
}

class _DataUsageScreenState extends State<DataUsageScreen> {
  bool _analyticsEnabled = true;
  bool _crashReportsEnabled = true;
  bool _personalizationEnabled = true;
  bool _locationEnabled = false;
  bool _cameraEnabled = true;
  bool _microphoneEnabled = true;
  bool _notificationsEnabled = true;
  bool _storageEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Data Usage & Permissions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Collection
            Text(
              'Data Collection',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage what data we collect to improve your experience',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Column(
                children: [
                  _buildPermissionItem(
                    icon: Icons.bar_chart,
                    iconColor: Colors.blue,
                    title: 'Analytics Data',
                    description: 'Help us improve the app',
                    value: _analyticsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _analyticsEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.bug_report_outlined,
                    iconColor: Colors.orange,
                    title: 'Crash Reports',
                    description: 'Automatically send crash reports',
                    value: _crashReportsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _crashReportsEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.person_outline,
                    iconColor: Colors.purple,
                    title: 'Personalization',
                    description: 'Personalized content recommendations',
                    value: _personalizationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _personalizationEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // App Permissions
            Text(
              'App Permissions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Control what the app can access on your device',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Column(
                children: [
                  _buildPermissionItem(
                    icon: Icons.location_on_outlined,
                    iconColor: Colors.red,
                    title: 'Location',
                    description: 'Access your location',
                    value: _locationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.camera_alt_outlined,
                    iconColor: Colors.blue,
                    title: 'Camera',
                    description: 'Take photos and videos',
                    value: _cameraEnabled,
                    onChanged: (value) {
                      setState(() {
                        _cameraEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.mic_outlined,
                    iconColor: Colors.green,
                    title: 'Microphone',
                    description: 'Record audio',
                    value: _microphoneEnabled,
                    onChanged: (value) {
                      setState(() {
                        _microphoneEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.notifications_outlined,
                    iconColor: Colors.orange,
                    title: 'Notifications',
                    description: 'Show notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildPermissionItem(
                    icon: Icons.storage_outlined,
                    iconColor: Colors.purple,
                    title: 'Storage',
                    description: 'Access files on your device',
                    value: _storageEnabled,
                    onChanged: (value) {
                      setState(() {
                        _storageEnabled = value;
                      });
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Data Usage Info
            Text(
              'Data Usage',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Column(
                children: [
                  _buildDataUsageRow('App Cache', '45.2 MB', isDark),
                  const SizedBox(height: 16),
                  _buildDataUsageRow('User Data', '12.8 MB', isDark),
                  const SizedBox(height: 16),
                  _buildDataUsageRow('Downloads', '128.5 MB', isDark),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showClearDataDialog();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Clear Cache',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildDataUsageRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cache?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will clear all cached data. This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cache cleared successfully',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
