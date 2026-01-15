enum ProjectDifficulty { beginner, intermediate, advanced, expert }

enum ProjectStatus { not_started, in_progress, completed, abandoned }

enum MilestoneStatus { locked, unlocked, in_progress, completed }

class LearningProject {
  final String id;
  final String title;
  final String description;
  final ProjectDifficulty difficulty;
  final List<Milestone> milestones;
  final List<String> technologies;
  final String? githubTemplate;
  final List<String> learningObjectives;
  final Duration estimatedDuration;
  final int totalPoints;
  final double totalDataRewardMB;

  // Security & Verification
  final bool requiresCodeReview;
  final List<String> reviewerIds;
  final bool plagiarismCheckEnabled;
  final String? blockchainCertificateId;

  LearningProject({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.milestones,
    required this.technologies,
    this.githubTemplate,
    required this.learningObjectives,
    required this.estimatedDuration,
    required this.totalPoints,
    required this.totalDataRewardMB,
    this.requiresCodeReview = true,
    this.reviewerIds = const [],
    this.plagiarismCheckEnabled = true,
    this.blockchainCertificateId,
  });

  int get completedMilestones => milestones.where((m) => m.isCompleted).length;
  double get progressPercentage => 
      completedMilestones / milestones.length * 100;
}

class Milestone {
  final String id;
  final String title;
  final String description;
  final List<MilestoneTask> tasks;
  final DateTime? deadline;
  final int points;
  final double dataRewardMB;
  final MilestoneStatus status;
  final List<String> deliverables;
  final String? submissionUrl;
  final DateTime? completedAt;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.tasks,
    this.deadline,
    required this.points,
    required this.dataRewardMB,
    this.status = MilestoneStatus.locked,
    required this.deliverables,
    this.submissionUrl,
    this.completedAt,
  });

  bool get isCompleted => status == MilestoneStatus.completed;
  bool get isUnlocked => status != MilestoneStatus.locked;
  int get completedTasks => tasks.where((t) => t.isCompleted).length;
}

class MilestoneTask {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final List<String> resources;

  MilestoneTask({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.resources = const [],
  });
}

class UserProject {
  final String id;
  final String userId;
  final String projectId;
  final DateTime startedAt;
  final ProjectStatus status;
  final int currentMilestoneIndex;
  final String? githubRepoUrl;
  final Map<String, bool> milestonesCompleted;
  final int totalPointsEarned;
  final double totalDataEarned;

  UserProject({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.startedAt,
    this.status = ProjectStatus.not_started,
    this.currentMilestoneIndex = 0,
    this.githubRepoUrl,
    this.milestonesCompleted = const {},
    this.totalPointsEarned = 0,
    this.totalDataEarned = 0,
  });
}
