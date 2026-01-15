import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/study_group_model.dart';
import 'package:phenoxx/services/study_group_service.dart';
import 'study_group_details_screen.dart';

class AIGroupMatcherScreen extends StatefulWidget {
  const AIGroupMatcherScreen({super.key});

  @override
  State<AIGroupMatcherScreen> createState() => _AIGroupMatcherScreenState();
}

class _AIGroupMatcherScreenState extends State<AIGroupMatcherScreen> {
  final StudyGroupService _groupService = StudyGroupService();
  late List<AIMatchScore> _matches;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _findMatches();
  }

  void _findMatches() {
    setState(() => _isLoading = true);

    // Mock user data - TODO: Get from user profile
    final userSkills = ['Python', 'JavaScript', 'React'];
    final userInterests = ['Web Development', 'AI', 'Mobile Apps'];

    _matches = _groupService.getRecommendedGroups(
      userId: 'current_user',
      userSkills: userSkills,
      userInterests: userInterests,
      learningPace: 7.5,
      hoursPerWeek: 10,
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Group Matcher',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];
                final group = _groupService.getGroupById(match.groupId)!;
                
                return _MatchCard(
                  group: group,
                  matchScore: match,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyGroupDetailsScreen(group: group),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final StudyGroup group;
  final AIMatchScore matchScore;
  final bool isDark;
  final VoidCallback onTap;

  const _MatchCard({
    required this.group,
    required this.matchScore,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = matchScore.isHighMatch
        ? Colors.green
        : matchScore.isGoodMatch
            ? Colors.blue
            : Colors.orange;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scoreColor.withOpacity(0.3), width: 2),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, size: 16, color: scoreColor),
                      const SizedBox(width: 4),
                      Text(
                        '${matchScore.compatibilityScore.toInt()}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...matchScore.matchingReasons.map((reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: scoreColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reason,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
