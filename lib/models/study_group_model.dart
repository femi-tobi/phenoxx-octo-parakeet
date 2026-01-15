enum GroupPrivacy { public, private, inviteOnly }

enum StudyLevel { beginner, intermediate, advanced, expert }

enum GroupRole { member, moderator, leader }

enum GroupStatus { active, inactive, archived }

class StudyGroup {
  final String id;
  final String name;
  final String description;
  final List<String> topics;
  final List<String> memberIds;
  final int maxMembers;
  final String leaderId;
  final GroupPrivacy privacy;
  final DateTime createdAt;
  final StudyLevel targetLevel;
  final List<String> goals;
  final String? imageUrl;
  final GroupStatus status;

  // Security features
  final bool requiresApproval;
  final String? encryptedInviteCode;
  final Map<String, GroupRole> memberRoles;
  final bool isVerifiedGroup; // Verified by admin

  // Analytics
  final int totalMessages;
  final int totalProjects;
  final DateTime? lastActivityAt;

  StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.topics,
    required this.memberIds,
    required this.maxMembers,
    required this.leaderId,
    required this.privacy,
    required this.createdAt,
    required this.targetLevel,
    required this.goals,
    this.imageUrl,
    this.status = GroupStatus.active,
    this.requiresApproval = false,
    this.encryptedInviteCode,
    this.memberRoles = const {},
    this.isVerifiedGroup = false,
    this.totalMessages = 0,
    this.totalProjects = 0,
    this.lastActivityAt,
  });

  bool get isFull => memberIds.length >= maxMembers;
  bool get isPublic => privacy == GroupPrivacy.public;
  bool get isPrivate => privacy == GroupPrivacy.private;
  int get availableSpots => maxMembers - memberIds.length;
  
  String get privacyLabel {
    switch (privacy) {
      case GroupPrivacy.public:
        return 'Public';
      case GroupPrivacy.private:
        return 'Private';
      case GroupPrivacy.inviteOnly:
        return 'Invite Only';
    }
  }

  String get levelLabel {
    switch (targetLevel) {
      case StudyLevel.beginner:
        return 'Beginner';
      case StudyLevel.intermediate:
        return 'Intermediate';
      case StudyLevel.advanced:
        return 'Advanced';
      case StudyLevel.expert:
        return 'Expert';
    }
  }

  StudyGroup copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? topics,
    List<String>? memberIds,
    int? maxMembers,
    String? leaderId,
    GroupPrivacy? privacy,
    DateTime? createdAt,
    StudyLevel? targetLevel,
    List<String>? goals,
    String? imageUrl,
    GroupStatus? status,
    bool? requiresApproval,
    String? encryptedInviteCode,
    Map<String, GroupRole>? memberRoles,
    bool? isVerifiedGroup,
    int? totalMessages,
    int? totalProjects,
    DateTime? lastActivityAt,
  }) {
    return StudyGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      topics: topics ?? this.topics,
      memberIds: memberIds ?? this.memberIds,
      maxMembers: maxMembers ?? this.maxMembers,
      leaderId: leaderId ?? this.leaderId,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      targetLevel: targetLevel ?? this.targetLevel,
      goals: goals ?? this.goals,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      encryptedInviteCode: encryptedInviteCode ?? this.encryptedInviteCode,
      memberRoles: memberRoles ?? this.memberRoles,
      isVerifiedGroup: isVerifiedGroup ?? this.isVerifiedGroup,
      totalMessages: totalMessages ?? this.totalMessages,
      totalProjects: totalProjects ?? this.totalProjects,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }
}

class GroupMember {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final List<String> skills;
  final double learningPace; // 0-10 (AI-calculated)
  final DateTime joinedAt;
  final GroupRole role;
  final bool isVerified; // Email verified
  final int contributionScore; // Based on activity
  final DateTime? lastSeenAt;

  // Preferences
  final List<String> preferredTopics;
  final int hoursPerWeek; // Study commitment

  GroupMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.skills,
    required this.learningPace,
    required this.joinedAt,
    required this.role,
    this.isVerified = false,
    this.contributionScore = 0,
    this.lastSeenAt,
    this.preferredTopics = const [],
    this.hoursPerWeek = 5,
  });

  bool get isOnline {
    if (lastSeenAt == null) return false;
    final difference = DateTime.now().difference(lastSeenAt!);
    return difference.inMinutes < 5;
  }

  String get roleLabel {
    switch (role) {
      case GroupRole.member:
        return 'Member';
      case GroupRole.moderator:
        return 'Moderator';
      case GroupRole.leader:
        return 'Leader';
    }
  }

  String get lastSeenLabel {
    if (lastSeenAt == null) return 'Never';
    if (isOnline) return 'Online';
    
    final difference = DateTime.now().difference(lastSeenAt!);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class GroupJoinRequest {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String message;
  final DateTime requestedAt;
  final RequestStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;

  GroupJoinRequest({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.message,
    required this.requestedAt,
    this.status = RequestStatus.pending,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
  });
}

enum RequestStatus { pending, approved, rejected }

class AIMatchScore {
  final String groupId;
  final double compatibilityScore; // 0-100
  final List<String> matchingReasons;
  final List<String> considerations;
  final Map<String, double> criteriaScores; // skill_match, pace_match, etc.

  AIMatchScore({
    required this.groupId,
    required this.compatibilityScore,
    required this.matchingReasons,
    required this.considerations,
    required this.criteriaScores,
  });

  bool get isHighMatch => compatibilityScore >= 80;
  bool get isGoodMatch => compatibilityScore >= 60;
}
