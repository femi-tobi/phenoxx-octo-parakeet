import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityCheckupScreen extends StatelessWidget {
  const SecurityCheckupScreen({super.key});

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
          'Security Checkup',
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
            // Overall Security Status
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Account is Secure',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'All security checks passed',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatItem('8/8', 'Checks Passed', Colors.white),
                      const SizedBox(width: 20),
                      _buildStatItem('100%', 'Security Score', Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Security Checks
            Text(
              'Security Checks',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            _buildCheckSection(
              context,
              isDark,
              'Account Protection',
              [
                _CheckItem(
                  icon: Icons.shield_outlined,
                  title: 'Two-Factor Authentication',
                  description: 'Enabled',
                  isActive: true,
                ),
                _CheckItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  description: 'Face ID active',
                  isActive: true,
                ),
                _CheckItem(
                  icon: Icons.lock_clock,
                  title: 'Password Strength',
                  description: 'Strong password detected',
                  isActive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildCheckSection(
              context,
              isDark,
              'Device Security',
              [
                _CheckItem(
                  icon: Icons.phone_android,
                  title: 'Trusted Devices',
                  description: '2 devices registered',
                  isActive: true,
                ),
                _CheckItem(
                  icon: Icons.location_on_outlined,
                  title: 'Login Location',
                  description: 'No suspicious activity',
                  isActive: true,
                ),
                _CheckItem(
                  icon: Icons.wifi_lock,
                  title: 'Secure Connection',
                  description: 'SSL/TLS enabled',
                  isActive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildCheckSection(
              context,
              isDark,
              'Data Protection',
              [
                _CheckItem(
                  icon: Icons.cloud_done_outlined,
                  title: 'Data Backup',
                  description: 'Last backup: Today',
                  isActive: true,
                ),
                _CheckItem(
                  icon: Icons.vpn_key,
                  title: 'Encryption',
                  description: 'End-to-end encryption active',
                  isActive: true,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recommendations (optional section)
            Text(
              'Recommendations',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Great job! Keep your security settings updated regularly.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
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

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckSection(
    BuildContext context,
    bool isDark,
    String title,
    List<_CheckItem> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildCheckItem(context, isDark, item),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, bool isDark, _CheckItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: item.isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          item.icon,
          color: item.isActive ? Colors.green : Colors.orange,
          size: 24,
        ),
      ),
      title: Text(
        item.title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        item.description,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      trailing: Icon(
        item.isActive ? Icons.check_circle : Icons.info_outline,
        color: item.isActive ? Colors.green : Colors.orange,
        size: 20,
      ),
    );
  }
}

class _CheckItem {
  final IconData icon;
  final String title;
  final String description;
  final bool isActive;

  _CheckItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
  });
}
