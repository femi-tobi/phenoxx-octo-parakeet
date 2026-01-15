import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/micro_task_model.dart';
import 'package:phenoxx/services/micro_task_service.dart';

class TaskDetailsScreen extends StatelessWidget {
  final MicroTask task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isAssigned = task.assignedMenteeIds.contains('current_user');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Task Details',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Mentor info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Text(
                    task.mentorName[0],
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.mentorName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Mentor',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _StatBox(
                  icon: Icons.timer,
                  label: 'Estimated',
                  value: '${task.estimatedTime.inHours}h',
                  color: Colors.blue,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  icon: Icons.star,
                  label: 'Reward',
                  value: '${task.pointsReward} pts',
                  color: Colors.orange,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  icon: Icons.wifi,
                  label: 'Data',
                  value: '+${task.dataRewardMB.toInt()} MB',
                  color: Colors.green,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Skills Required
            Text(
              'Skills Required',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.skillsRequired.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Deadline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAssigned
                    ? () {
                        // TODO: Navigate to submission screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Submission screen - To be implemented')),
                        );
                      }
                    : () {
                        final service = MicroTaskService();
                        service.assignTask(task.id, 'current_user');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task assigned successfully!')),
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isAssigned ? 'Submit Task' : 'Accept Task',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
