import 'package:phenoxx/models/study_group_model.dart';
import 'package:phenoxx/services/encryption_service.dart';

/// Service for managing study groups with AI-powered matching
/// TODO Backend: Replace mock data with API calls to /api/study-groups
class StudyGroupService {
  // Singleton pattern
  static final StudyGroupService _instance = StudyGroupService._internal();
  factory StudyGroupService() => _instance;
  StudyGroupService._internal();

  final EncryptionService _encryption = EncryptionService();

  // Mock data - Replace with API calls
  final List<StudyGroup> _mockGroups = [];
  final List<GroupMember> _mockMembers = [];
  final List<GroupJoinRequest> _mockRequests = [];

  StudyGroupService._() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final encryptionService = EncryptionService();
    
    _mockGroups.addAll([
      StudyGroup(
        id: 'group_1',
        name: 'Python Beginners Circle',
        description: 'Learn Python together! From basics to data structures. No prior experience needed.',
        topics: ['Python', 'Programming Basics', 'Data Structures'],
        memberIds: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5'],
        maxMembers: 15,
        leaderId: 'user_1',
        privacy: GroupPrivacy.public,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        targetLevel: StudyLevel.beginner,
        goals: [
          'Complete Python basics course',
          'Build 3 small projects',
          'Prepare for certification',
        ],
        requiresApproval: false,
        isVerifiedGroup: true,
        totalMessages: 234,
        totalProjects: 5,
        lastActivityAt: DateTime.now().subtract(const Duration(hours: 2)),
        memberRoles: {
          'user_1': GroupRole.leader,
          'user_2': GroupRole.moderator,
        },
      ),
      StudyGroup(
        id: 'group_2',
        name: 'Web Dev Mastery',
        description: 'Full-stack web development with React, Node.js, and MongoDB. Advanced topics only.',
        topics: ['React', 'Node.js', 'MongoDB', 'Full Stack'],
        memberIds: ['user_6', 'user_7', 'user_8', 'user_9', 'user_10', 'user_11'],
        maxMembers: 12,
        leaderId: 'user_6',
        privacy: GroupPrivacy.private,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        targetLevel: StudyLevel.advanced,
        goals: [
          'Build a full-stack application',
          'Master authentication & security',
          'Deploy to production',
        ],
        requiresApproval: true,
        encryptedInviteCode: encryptionService.encryptData('WEB2024'),
        isVerifiedGroup: true,
        totalMessages: 567,
        totalProjects: 8,
        lastActivityAt: DateTime.now().subtract(const Duration(minutes: 30)),
        memberRoles: {
          'user_6': GroupRole.leader,
          'user_7': GroupRole.moderator,
          'user_8': GroupRole.moderator,
        },
      ),
      StudyGroup(
        id: 'group_3',
        name: 'Flutter Mobile Dev',
        description: 'Building beautiful mobile apps with Flutter & Dart. Intermediate level.',
        topics: ['Flutter', 'Dart', 'Mobile Development', 'UI/UX'],
        memberIds: ['user_12', 'user_13', 'user_14', 'user_15'],
        maxMembers: 10,
        leaderId: 'user_12',
        privacy: GroupPrivacy.inviteOnly,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        targetLevel: StudyLevel.intermediate,
        goals: [
          'Build portfolio app',
          'Master state management',
          'Publish to app stores',
        ],
        requiresApproval: true,
        encryptedInviteCode: encryptionService.encryptData('FLUTTER'),
        isVerifiedGroup: false,
        totalMessages: 123,
        totalProjects: 3,
        lastActivityAt: DateTime.now().subtract(const Duration(hours: 1)),
        memberRoles: {
          'user_12': GroupRole.leader,
          'user_13': GroupRole.moderator,
        },
      ),
      StudyGroup(
        id: 'group_4',
        name: 'AI & Machine Learning',
        description: 'Explore AI, ML, and deep learning. Work on real-world projects with TensorFlow and PyTorch.',
        topics: ['AI', 'Machine Learning', 'Python', 'TensorFlow', 'PyTorch'],
        memberIds: ['user_16', 'user_17', 'user_18', 'user_19', 'user_20'],
        maxMembers: 20,
        leaderId: 'user_16',
        privacy: GroupPrivacy.public,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        targetLevel: StudyLevel.expert,
        goals: [
          'Complete ML specialization',
          'Build 3 AI projects',
          'Contribute to open source',
        ],
        requiresApproval: false,
        isVerifiedGroup: true,
        totalMessages: 891,
        totalProjects: 12,
        lastActivityAt: DateTime.now().subtract(const Duration(hours: 5)),
        memberRoles: {
          'user_16': GroupRole.leader,
          'user_17': GroupRole.moderator,
          'user_18': GroupRole.moderator,
        },
      ),
      StudyGroup(
        id: 'group_5',
        name: 'DevOps & Cloud',
        description: 'Master DevOps practices, AWS, Docker, Kubernetes, and CI/CD pipelines.',
        topics: ['DevOps', 'AWS', 'Docker', 'Kubernetes', 'CI/CD'],
        memberIds: ['user_21', 'user_22', 'user_23'],
        maxMembers: 8,
        leaderId: 'user_21',
        privacy: GroupPrivacy.private,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        targetLevel: StudyLevel.intermediate,
        goals: [
          'Get AWS certification',
          'Set up production pipeline',
          'Master containerization',
        ],
        requiresApproval: true,
        encryptedInviteCode: encryptionService.encryptData('DEVOPS'),
        isVerifiedGroup: true,
        totalMessages: 342,
        totalProjects: 6,
        lastActivityAt: DateTime.now().subtract(const Duration(days: 1)),
        memberRoles: {
          'user_21': GroupRole.leader,
          'user_22': GroupRole.moderator,
        },
      ),
      StudyGroup(
        id: 'group_6',
        name: 'Cybersecurity Fundamentals',
        description: 'Learn ethical hacking, network security, and cybersecurity best practices.',
        topics: ['Cybersecurity', 'Ethical Hacking', 'Network Security'],
        memberIds: ['user_24', 'user_25', 'user_26', 'user_27'],
        maxMembers: 15,
        leaderId: 'user_24',
        privacy: GroupPrivacy.public,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        targetLevel: StudyLevel.beginner,
        goals: [
          'Complete security+ course',
          'Practice in labs',
          'Build security toolkit',
        ],
        requiresApproval: false,
        isVerifiedGroup: false,
        totalMessages: 156,
        totalProjects: 2,
        lastActivityAt: DateTime.now().subtract(const Duration(hours: 6)),
        memberRoles: {
          'user_24': GroupRole.leader,
        },
      ),
    ]);
  }

  /// Get all study groups
  /// TODO Backend: GET /api/study-groups
  List<StudyGroup> getAllGroups() {
    return _mockGroups.where((g) => g.status == GroupStatus.active).toList();
  }

  /// Get groups by topic
  /// TODO Backend: GET /api/study-groups?topic={topic}
  List<StudyGroup> getGroupsByTopic(String topic) {
    return _mockGroups
        .where((g) => g.topics.any((t) => t.toLowerCase().contains(topic.toLowerCase())))
        .toList();
  }

  /// Get groups by level
  /// TODO Backend: GET /api/study-groups?level={level}
  List<StudyGroup> getGroupsByLevel(StudyLevel level) {
    return _mockGroups.where((g) => g.targetLevel == level).toList();
  }

  /// Search groups
  /// TODO Backend: GET /api/study-groups/search?q={query}
  List<StudyGroup> searchGroups(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockGroups.where((g) {
      return g.name.toLowerCase().contains(lowerQuery) ||
          g.description.toLowerCase().contains(lowerQuery) ||
          g.topics.any((t) => t.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Get group details
  /// TODO Backend: GET /api/study-groups/{id}
  StudyGroup? getGroupById(String id) {
    try {
      return _mockGroups.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get recommended groups using AI matching
  /// TODO Backend: POST /api/study-groups/recommendations
  /// Body: { userId, skills, interests, learningPace, hoursPerWeek }
  List<AIMatchScore> getRecommendedGroups({
    required String userId,
    required List<String> userSkills,
    required List<String> userInterests,
    required double learningPace,
    required int hoursPerWeek,
  }) {
    final scores = <AIMatchScore>[];

    for (final group in _mockGroups) {
      // Calculate compatibility score (Mock AI algorithm)
      double skillMatch = _calculateSkillMatch(userSkills, group.topics);
      double topicMatch = _calculateTopicMatch(userInterests, group.topics);
      double availabilityScore = group.isFull ? 0 : 100;
      double activityScore = _calculateActivityScore(group);

      double totalScore = (skillMatch * 0.3) +
          (topicMatch * 0.3) +
          (availabilityScore * 0.2) +
          (activityScore * 0.2);

      final reasons = <String>[];
      final considerations = <String>[];

      if (skillMatch > 70) reasons.add('${(skillMatch).toInt()}% skill match');
      if (topicMatch > 70) reasons.add('Shares ${userInterests.where((i) => group.topics.contains(i)).length} interests');
      if (activityScore > 80) reasons.add('Very active group');
      if (!group.isFull) reasons.add('${group.availableSpots} spots available');

      if (group.requiresApproval) considerations.add('Requires approval to join');
      if (group.privacy == GroupPrivacy.private) considerations.add('Private group');

      scores.add(AIMatchScore(
        groupId: group.id,
        compatibilityScore: totalScore,
        matchingReasons: reasons,
        considerations: considerations,
        criteriaScores: {
          'skill_match': skillMatch,
          'topic_match': topicMatch,
          'availability': availabilityScore,
          'activity': activityScore,
        },
      ));
    }

    // Sort by score
    scores.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    return scores.take(5).toList();
  }

  double _calculateSkillMatch(List<String> userSkills, List<String> groupTopics) {
    if (userSkills.isEmpty) return 50.0;
    int matches = 0;
    for (final skill in userSkills) {
      if (groupTopics.any((t) => t.toLowerCase().contains(skill.toLowerCase()))) {
        matches++;
      }
    }
    return (matches / userSkills.length) * 100;
  }

  double _calculateTopicMatch(List<String> userInterests, List<String> groupTopics) {
    if (userInterests.isEmpty) return 50.0;
    int matches = 0;
    for (final interest in userInterests) {
      if (groupTopics.any((t) => t.toLowerCase().contains(interest.toLowerCase()))) {
        matches++;
      }
    }
    return (matches / userInterests.length) * 100;
  }

  double _calculateActivityScore(StudyGroup group) {
    if (group.lastActivityAt == null) return 30.0;
    final hoursSinceActivity = DateTime.now().difference(group.lastActivityAt!).inHours;
    if (hoursSinceActivity < 1) return 100.0;
    if (hoursSinceActivity < 6) return 90.0;
    if (hoursSinceActivity < 24) return 70.0;
    if (hoursSinceActivity < 72) return 50.0;
    return 30.0;
  }

  /// Create new study group
  /// TODO Backend: POST /api/study-groups
  StudyGroup createGroup({
    required String name,
    required String description,
    required List<String> topics,
    required String leaderId,
    required GroupPrivacy privacy,
    required StudyLevel targetLevel,
    required List<String> goals,
    int maxMembers = 10,
    bool requiresApproval = false,
  }) {
    final id = 'group_${DateTime.now().millisecondsSinceEpoch}';
    String? inviteCode;

    if (privacy != GroupPrivacy.public) {
      final code = _encryption.generateInviteCode();
      inviteCode = _encryption.encryptData(code);
    }

    final group = StudyGroup(
      id: id,
      name: name,
      description: description,
      topics: topics,
      memberIds: [leaderId],
      maxMembers: maxMembers,
      leaderId: leaderId,
      privacy: privacy,
      createdAt: DateTime.now(),
      targetLevel: targetLevel,
      goals: goals,
      requiresApproval: requiresApproval,
      encryptedInviteCode: inviteCode,
      memberRoles: {leaderId: GroupRole.leader},
    );

    _mockGroups.add(group);
    return group;
  }

  /// Join group
  /// TODO Backend: POST /api/study-groups/{id}/join
  bool joinGroup(String groupId, String userId) {
    final group = getGroupById(groupId);
    if (group == null || group.isFull) return false;

    if (group.requiresApproval) {
      // Create join request instead
      _mockRequests.add(GroupJoinRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        groupId: groupId,
        userId: userId,
        userName: 'User $userId',
        message: 'I would like to join this group',
        requestedAt: DateTime.now(),
      ));
      return false; // Pending approval
    }

    // Direct join
    final updatedMembers = List<String>.from(group.memberIds)..add(userId);
    final index = _mockGroups.indexWhere((g) => g.id == groupId);
    _mockGroups[index] = group.copyWith(memberIds: updatedMembers);
    return true;
  }

  /// Leave group
  /// TODO Backend: POST /api/study-groups/{id}/leave
  bool leaveGroup(String groupId, String userId) {
    final group = getGroupById(groupId);
    if (group == null) return false;

    final updatedMembers = List<String>.from(group.memberIds)..remove(userId);
    final index = _mockGroups.indexWhere((g) => g.id == groupId);
    _mockGroups[index] = group.copyWith(memberIds: updatedMembers);
    return true;
  }

  /// Verify invite code
  /// TODO Backend: POST /api/study-groups/{id}/verify-code
  bool verifyInviteCode(String groupId, String code) {
    final group = getGroupById(groupId);
    if (group == null || group.encryptedInviteCode == null) return false;

    try {
      final decryptedCode = _encryption.decryptData(group.encryptedInviteCode!);
      return decryptedCode.toUpperCase() == code.toUpperCase();
    } catch (e) {
      return false;
    }
  }

  /// Get user's groups
  /// TODO Backend: GET /api/users/{userId}/study-groups
  List<StudyGroup> getUserGroups(String userId) {
    return _mockGroups.where((g) => g.memberIds.contains(userId)).toList();
  }
}
