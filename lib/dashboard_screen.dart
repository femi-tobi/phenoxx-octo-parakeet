import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/widgets/circular_progress.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Welcome Section
              Text(
                'Welcome back, Alex!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to continue your Python project?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Income Health',
                      value: '85',
                      icon: Icons.trending_up,
                      iconColor: Colors.green,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Skills Progress',
                      value: 'Lvl 3',
                      icon: Icons.flash_on,
                      iconColor: Colors.amber,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: isDark ? Border.all(color: Colors.grey[800]!) : null,
                ),
                child: Column(
                  children: [
                    const CircularProgress(
                      percentage: 65,
                      size: 140,
                      strokeWidth: 10,
                      progressColor: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CURRENT FOCUS: Build Django E-commerce Site',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Weekly Savings :\$150/\$200',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue[400],
                      ),
                    ),
                    Text(
                      'Next: Deploy to Heroku',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Navigation Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _NavCard(
                    icon: Icons.chat_bubble_outline,
                    label: 'AI Chat',
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                  _NavCard(
                    icon: Icons.school_outlined,
                    label: 'Learn',
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                  _NavCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Earn',
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                  _NavCard(
                    icon: Icons.groups_outlined,
                    label: 'Community',
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Income Streams
              Text(
                'Income Streams',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _IncomeCard(
                      title: 'Freelance',
                      amount: '\$1,200/mo',
                      trend: '+15%',
                      isPositive: true,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IncomeCard(
                      title: 'Tutoring',
                      amount: '\$300/mo',
                      trend: 'Stable',
                      isPositive: null,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: iconColor, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String trend;
  final bool? isPositive;
  final bool isDark;

  const _IncomeCard({
    required this.title,
    required this.amount,
    required this.trend,
    required this.isPositive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (isPositive != null)
                Icon(
                  isPositive! ? Icons.trending_up : Icons.trending_down,
                  color: isPositive! ? Colors.green : Colors.red,
                  size: 14,
                ),
              if (isPositive != null) const SizedBox(width: 4),
              Text(
                trend,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isPositive == null
                      ? Colors.grey[600]
                      : (isPositive! ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
