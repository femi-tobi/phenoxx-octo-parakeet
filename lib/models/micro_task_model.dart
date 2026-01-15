enum TaskType { code_review, bug_fix, feature, research, documentation, testing }

enum TaskStatus { open, assigned, in_progress, submitted, under_review, completed, rejected }

enum TaskDifficulty { beginner, intermediate, advanced }

class MicroTask {
  final String id;
  final String title;
  final String description;
  final String mentorId;
  final String mentorName;
  final List<String> assignedMenteeIds;
  final TaskType type;
  final TaskDifficulty difficulty;
  final int pointsReward;
  final double dataRewardMB;
  final Duration estimatedTime;
  final DateTime deadline;
  final TaskStatus status;
  final List<String> skillsRequired;
  final DateTime createdAt;

  // Security
  final bool requiresVerification;
  final List<String> reviewerIds;
  final String? signedHash; // Digital signature

  MicroTask({
    required this.id,
    required this.title,
    required this.description,
    required this.mentorId,
    required this.mentorName,
    this.assignedMenteeIds = const [],
    required this.type,
    required this.difficulty,
    required this.pointsReward,
    required this.dataRewardMB,
    required this.estimatedTime,
    required this.deadline,
    this.status = TaskStatus.open,
    required this.skillsRequired,
    required this.createdAt,
    this.requiresVerification = true,
    this.reviewerIds = const [],
    this.signedHash,
  });

  bool get isOpen => status == TaskStatus.open;
  bool get isAssigned => assignedMenteeIds.isNotEmpty;
  bool get isOverdue => DateTime.now().isAfter(deadline);

  String get typeLabel {
    switch (type) {
      case TaskType.code_review:
        return 'Code Review';
      case TaskType.bug_fix:
        return 'Bug Fix';
      case TaskType.feature:
        return 'Feature';
      case TaskType.research:
        return 'Research';
      case TaskType.documentation:
        return 'Documentation';
      case TaskType.testing:
        return 'Testing';
    }
  }

  String get difficultyLabel {
    switch (difficulty) {
      case TaskDifficulty.beginner:
        return 'Beginner';
      case TaskDifficulty.intermediate:
        return 'Intermediate';
      case TaskDifficulty.advanced:
        return 'Advanced';
    }
  }
}

class TaskSubmission {
  final String id;
  final String taskId;
  final String menteeId;
  final String menteeName;
  final DateTime submittedAt;
  final String description;
  final List<String> fileUrls;
  final String? githubPr;
  final TaskStatus status;
  final String? feedback;
  final int? score; // 0-100
  final DateTime? reviewedAt;
  final String? reviewedBy;

  TaskSubmission({
    required this.id,
    required this.taskId,
    required this.menteeId,
    required this.menteeName,
    required this.submittedAt,
    required this.description,
    required this.fileUrls,
    this.githubPr,
    this.status = TaskStatus.under_review,
    this.feedback,
    this.score,
    this.reviewedAt,
    this.reviewedBy,
  });

  bool get isApproved => status == TaskStatus.completed;
  bool get isRejected => status == TaskStatus.rejected;
  bool get isPending => status == TaskStatus.under_review;
}
