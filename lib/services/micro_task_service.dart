import 'package:phenoxx/models/micro_task_model.dart';
import 'package:phenoxx/services/encryption_service.dart';

/// Service for micro-tasks with mentor assignment
/// TODO Backend: POST /api/micro-tasks
class MicroTaskService {
  static final MicroTaskService _instance = MicroTaskService._internal();
  factory MicroTaskService() => _instance;
  MicroTaskService._internal();

  final EncryptionService _encryption = EncryptionService();

  final List<MicroTask> _mockTasks = [
    MicroTask(
      id: 'task_1',
      title: 'Review Pull Request: User Authentication',
      description: 'Review the authentication module PR, check for security issues and code quality. Focus on input validation and error handling.',
      mentorId: 'mentor_1',
      mentorName: 'Sarah Johnson',
      type: TaskType.code_review,
      difficulty: TaskDifficulty.intermediate,
      pointsReward: 50,
      dataRewardMB: 25,
      estimatedTime: const Duration(hours: 2),
      deadline: DateTime.now().add(const Duration(days: 3)),
      skillsRequired: ['Flutter', 'Dart', 'Security'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.open,
      signedHash: 'hash_task_1',
    ),
    MicroTask(
      id: 'task_2',
      title: 'Fix: Login Button Not Responding',
      description: 'Users report login button sometimes doesn\'t respond on first tap. Debug and fix the issue.',
      mentorId: 'mentor_2',
      mentorName: 'Michael Chen',
      type: TaskType.bug_fix,
      difficulty: TaskDifficulty.beginner,
      pointsReward: 30,
      dataRewardMB: 15,
      estimatedTime: const Duration(hours: 1),
      deadline: DateTime.now().add(const Duration(days: 2)),
      skillsRequired: ['Flutter', 'UI/UX'],
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: TaskStatus.assigned,
      assignedMenteeIds: ['current_user'],
      signedHash: 'hash_task_2',
    ),
    MicroTask(
      id: 'task_3',
      title: 'Implement Dark Mode Toggle',
      description: 'Add a dark mode toggle to the settings screen with smooth animations.',
      mentorId: 'mentor_1',
      mentorName: 'Sarah Johnson',
      type: TaskType.feature,
      difficulty: TaskDifficulty.beginner,
      pointsReward: 40,
      dataRewardMB: 20,
      estimatedTime: const Duration(hours: 3),
      deadline: DateTime.now().add(const Duration(days: 5)),
      skillsRequired: ['Flutter', 'State Management'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: TaskStatus.open,
      signedHash: 'hash_task_3',
    ),
    MicroTask(
      id: 'task_4',
      title: 'Research: Best Practices for API Rate Limiting',
      description: 'Research and document best practices for implementing API rate limiting in Flutter apps.',
      mentorId: 'mentor_3',
      mentorName: 'David Kumar',
      type: TaskType.research,
      difficulty: TaskDifficulty.advanced,
      pointsReward: 60,
      dataRewardMB: 30,
      estimatedTime: const Duration(hours: 4),
      deadline: DateTime.now().add(const Duration(days: 7)),
      skillsRequired: ['Backend', 'Security', 'Research'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: TaskStatus.open,
      requiresVerification: true,
      signedHash: 'hash_task_4',
    ),
  ];

  /// Get all available tasks
  /// TODO Backend: GET /api/micro-tasks
  List<MicroTask> getAllTasks() {
    return _mockTasks;
  }

  /// Get tasks by difficulty
  List<MicroTask> getTasksByDifficulty(TaskDifficulty difficulty) {
    return _mockTasks.where((t) => t.difficulty == difficulty).toList();
  }

  /// Get open tasks (not assigned)
  List<MicroTask> getOpenTasks() {
    return _mockTasks.where((t) => t.isOpen).toList();
  }

  /// Get user's assigned tasks
  /// TODO Backend: GET /api/micro-tasks/assigned/{userId}
  List<MicroTask> getUserTasks(String userId) {
    return _mockTasks.where((t) => t.assignedMenteeIds.contains(userId)).toList();
  }

  /// Assign task to user
  /// TODO Backend: POST /api/micro-tasks/{id}/assign
  bool assignTask(String taskId, String userId) {
    final index = _mockTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final task = _mockTasks[index];
    final updatedIds = List<String>.from(task.assignedMenteeIds)..add(userId);
    
    // Create new task with updated assignees
    _mockTasks[index] = MicroTask(
      id: task.id,
      title: task.title,
      description: task.description,
      mentorId: task.mentorId,
      mentorName: task.mentorName,
      assignedMenteeIds: updatedIds,
      type: task.type,
      difficulty: task.difficulty,
      pointsReward: task.pointsReward,
      dataRewardMB: task.dataRewardMB,
      estimatedTime: task.estimatedTime,
      deadline: task.deadline,
      status: TaskStatus.assigned,
      skillsRequired: task.skillsRequired,
      createdAt: task.createdAt,
      requiresVerification: task.requiresVerification,
      reviewerIds: task.reviewerIds,
      signedHash: task.signedHash,
    );

    return true;
  }

  /// Submit task
  /// TODO Backend: POST /api/micro-tasks/{id}/submit
  TaskSubmission submitTask({
    required String taskId,
    required String userId,
    required String description,
    List<String> fileUrls = const [],
    String? githubPr,
  }) {
    return TaskSubmission(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      taskId: taskId,
      menteeId: userId,
      menteeName: 'Current User',
      submittedAt: DateTime.now(),
      description: description,
      fileUrls: fileUrls,
      githubPr: githubPr,
    );
  }
}
