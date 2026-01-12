import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.2),
                    Colors.purple.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield_outlined, color: Colors.blue, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Last updated: January 12, 2026',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Policy Sections
            _buildPolicySection(
              context,
              isDark,
              '1. Information We Collect',
              'We collect information you provide directly to us, such as:\n\n'
              '• Account information (name, email, profile picture)\n'
              '• Usage data (app interactions, preferences)\n'
              '• Device information (device type, operating system)\n'
              '• Location data (if you enable location services)\n\n'
              'We only collect information necessary to provide and improve our services.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n'
              '• Provide, maintain, and improve our services\n'
              '• Personalize your experience\n'
              '• Send you updates and notifications\n'
              '• Respond to your requests and support needs\n'
              '• Protect against fraud and abuse\n'
              '• Comply with legal obligations',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '3. Information Sharing',
              'We do not sell your personal information. We may share your information only in these circumstances:\n\n'
              '• With your consent\n'
              '• With service providers who assist us\n'
              '• To comply with legal obligations\n'
              '• To protect our rights and safety\n\n'
              'All third parties are required to protect your data in compliance with this policy.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '4. Data Security',
              'We implement industry-standard security measures to protect your information:\n\n'
              '• End-to-end encryption for sensitive data\n'
              '• Secure servers with SSL/TLS protection\n'
              '• Regular security audits and updates\n'
              '• Access controls and authentication\n\n'
              'However, no method of transmission over the internet is 100% secure.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '5. Your Rights and Choices',
              'You have the right to:\n\n'
              '• Access your personal information\n'
              '• Correct or update your information\n'
              '• Delete your account and data\n'
              '• Opt-out of marketing communications\n'
              '• Control app permissions\n'
              '• Export your data\n\n'
              'You can exercise these rights through your account settings or by contacting us.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '6. Cookies and Tracking',
              'We use cookies and similar technologies to:\n\n'
              '• Remember your preferences\n'
              '• Improve app performance\n'
              '• Analyze usage patterns\n\n'
              'You can control cookie settings through your device preferences.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '7. Children\'s Privacy',
              'Our service is not intended for children under 13. We do not knowingly collect personal information from children. '
              'If you believe we have collected information from a child, please contact us immediately.',
            ),
            const SizedBox(height: 16),

            _buildPolicySection(
              context,
              isDark,
              '8. Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page '
              'and updating the "Last updated" date. Your continued use of the app after changes indicates acceptance.',
            ),
            const SizedBox(height: 24),

            // Contact Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'If you have any questions about this Privacy Policy, please contact us:',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.email_outlined, 'support@phenoxx.com', isDark),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.language, 'www.phenoxx.com/privacy', isDark),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(
    BuildContext context,
    bool isDark,
    String title,
    String content,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
