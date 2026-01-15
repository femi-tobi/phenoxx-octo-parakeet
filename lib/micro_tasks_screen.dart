import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/micro_task_model.dart';
import 'package:phenoxx/services/micro_task_service.dart';
import 'task_details_screen.dart';

class MicroTasksScreen extends StatefulWidget {
  const MicroTasksScreen({super.key});

  @override
  State<MicroTasksScreen> createState() => _MicroTasksScreenState();
}

class _MicroTasksScreenState extends State<MicroTasksScreen> with SingleTickerProviderStateMixin {
  final MicroTaskService _taskService = MicroTaskService();
  late TabController _tabController;
  TaskDifficulty? _filterDifficulty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final openTasks = _filterDifficulty == null
        ? _taskService.getOpenTasks()
        : _taskService.getTasksByDifficulty(_filterDifficulty!).where((t) => t.isOpen).toList();
    final myTasks = _taskService.getUserTasks('current_user');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Micro-Tasks',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[500],
          indicatorColor: Colors.blue,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: [
            Tab(text: 'Available (${openTasks.length})'),
            Tab(text: 'My Tasks (${myTasks.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _filterDifficulty == null,
                    onTap: () => setState(() => _filterDifficulty = null),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Beginner',
                    isSelected: _filterDifficulty == TaskDifficulty.beginner,
                    onTap: () => setState(() => _filterDifficulty = TaskDifficulty.beginner),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Intermediate',
                    isSelected: _filterDifficulty == TaskDifficulty.intermediate,
                    onTap: () => setState(() => _filterDifficulty = TaskDifficulty.intermediate),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Advanced',
                    isSelected: _filterDifficulty == TaskDifficulty.advanced,
                    onTap: () => setState(() => _filterDifficulty = TaskDifficulty.advanced),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Available Tasks
                openTasks.isEmpty
                    ? const Center(child: Text('No available tasks'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: openTasks.length,
                        itemBuilder: (context, index) {
                          return _TaskCard(
                            task: openTasks[index],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsScreen(task: openTasks[index]),
                                ),
                              ).then((_) => setState(() {}));
                            },
                          );
                        },
                      ),

                // My Tasks
                myTasks.isEmpty
                    ? const Center(child: Text('No assigned tasks yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: myTasks.length,
                        itemBuilder: (context, index) {
                          return _TaskCard(
                            task: myTasks[index],
                            isDark: isDark,
                            showProgress: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsScreen(task: myTasks[index]),
                                ),
                              ).then((_) => setState(() {}));
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final MicroTask task;
  final bool isDark;
  final bool showProgress;
  final VoidCallback onTap;

  const _TaskCard({
    required this.task,
    required this.isDark,
    this.showProgress = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyColor = task.difficulty == TaskDifficulty.beginner
        ? Colors.green
        : task.difficulty == TaskDifficulty.intermediate
            ? Colors.orange
            : Colors.red;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: Colors.grey[800]!) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(task.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(task.type),
                    color: _getTypeColor(task.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'by ${task.mentorName}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.description,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: task.skillsRequired.take(3).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blue,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${task.estimatedTime.inHours}h',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  '${task.pointsReward} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.wifi, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '+${task.dataRewardMB.toInt()} MB',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.difficultyLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: difficultyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.code_review:
        return Icons.rate_review;
      case TaskType.bug_fix:
        return Icons.bug_report;
      case TaskType.feature:
        return Icons.star;
      case TaskType.research:
        return Icons.science;
      case TaskType.documentation:
        return Icons.description;
      case TaskType.testing:
        return Icons.check_circle;
    }
  }

  Color _getTypeColor(TaskType type) {
    switch (type) {
      case TaskType.code_review:
        return Colors.purple;
      case TaskType.bug_fix:
        return Colors.red;
      case TaskType.feature:
        return Colors.blue;
      case TaskType.research:
        return Colors.green;
      case TaskType.documentation:
        return Colors.orange;
      case TaskType.testing:
        return Colors.teal;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : (isDark ? const Color(0xFF1A2332) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
