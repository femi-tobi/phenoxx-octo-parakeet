import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/study_group_model.dart';
import 'package:phenoxx/services/study_group_service.dart';
import 'study_group_details_screen.dart';
import 'create_study_group_screen.dart';
import 'ai_group_matcher_screen.dart';

class StudyGroupsScreen extends StatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  State<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> with SingleTickerProviderStateMixin {
  final StudyGroupService _groupService = StudyGroupService();
  late TabController _tabController;
  String _searchQuery = '';
  StudyLevel? _filterLevel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<StudyGroup> get _filteredGroups {
    var groups = _groupService.getAllGroups();

    if (_searchQuery.isNotEmpty) {
      groups = _groupService.searchGroups(_searchQuery);
    }

    if (_filterLevel != null) {
      groups = groups.where((g) => g.targetLevel == _filterLevel).toList();
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final myGroups = _groupService.getUserGroups('current_user');
    final publicGroups = _filteredGroups.where((g) => g.isPublic).toList();
    final privateGroups = _filteredGroups.where((g) => !g.isPublic).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Study Groups',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: 'AI Matcher',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AIGroupMatcherScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[500],
          indicatorColor: Colors.blue,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: 'My Groups (${myGroups.length})'),
            Tab(text: 'Public (${publicGroups.length})'),
            Tab(text: 'Private (${privateGroups.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateStudyGroupScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Create Group',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  style: GoogleFonts.poppins(color: textColor),
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search groups, topics...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _LevelFilterChip(
                        label: 'All Levels',
                        isSelected: _filterLevel == null,
                        onTap: () => setState(() => _filterLevel = null),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _LevelFilterChip(
                        label: 'Beginner',
                        isSelected: _filterLevel == StudyLevel.beginner,
                        onTap: () => setState(() => _filterLevel = StudyLevel.beginner),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _LevelFilterChip(
                        label: 'Intermediate',
                        isSelected: _filterLevel == StudyLevel.intermediate,
                        onTap: () => setState(() => _filterLevel = StudyLevel.intermediate),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _LevelFilterChip(
                        label: 'Advanced',
                        isSelected: _filterLevel == StudyLevel.advanced,
                        onTap: () => setState(() => _filterLevel = StudyLevel.advanced),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _LevelFilterChip(
                        label: 'Expert',
                        isSelected: _filterLevel == StudyLevel.expert,
                        onTap: () => setState(() => _filterLevel = StudyLevel.expert),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // My Groups
                myGroups.isEmpty
                    ? _EmptyState(
                        icon: Icons.groups,
                        message: 'Not in any groups yet',
                        subMessage: 'Join or create a study group to get started!',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: myGroups.length,
                        itemBuilder: (context, index) {
                          return _GroupCard(
                            group: myGroups[index],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudyGroupDetailsScreen(group: myGroups[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),

                // Public Groups
                publicGroups.isEmpty
                    ? _EmptyState(
                        icon: Icons.public,
                        message: 'No public groups found',
                        subMessage: 'Try different search terms',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: publicGroups.length,
                        itemBuilder: (context, index) {
                          return _GroupCard(
                            group: publicGroups[index],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudyGroupDetailsScreen(group: publicGroups[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),

                // Private Groups
                privateGroups.isEmpty
                    ? _EmptyState(
                        icon: Icons.lock,
                        message: 'No private groups found',
                        subMessage: 'Private groups require an invite code',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: privateGroups.length,
                        itemBuilder: (context, index) {
                          return _GroupCard(
                            group: privateGroups[index],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudyGroupDetailsScreen(group: privateGroups[index]),
                                ),
                              );
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

class _GroupCard extends StatelessWidget {
  final StudyGroup group;
  final bool isDark;
  final VoidCallback onTap;

  const _GroupCard({
    required this.group,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    group.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (group.isVerifiedGroup)
                  const Icon(Icons.verified, color: Colors.blue, size: 20),
                const SizedBox(width: 4),
                Icon(
                  group.privacy == GroupPrivacy.public ? Icons.public : Icons.lock,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              group.description,
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
              children: group.topics.take(3).map((topic) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    topic,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  '${group.memberIds.length}/${group.maxMembers} members',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  group.levelLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (group.isFull)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FULL',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${group.availableSpots} OPEN',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.green,
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
}

class _LevelFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _LevelFilterChip({
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
          border: isSelected
              ? null
              : Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subMessage;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subMessage,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
