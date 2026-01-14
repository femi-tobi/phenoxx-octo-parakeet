class Expert {
  final String id;
  final String name;
  final String bio;
  final String? avatarUrl;
  final String title; // e.g., "Senior Full-Stack Developer"
  
  // Expertise
  final List<String> skills;
  final List<String> specializations;
  final int yearsOfExperience;
  
  // Stats
  final double rating;
  final int totalReviews;
  final int totalSessions;
  final int totalStudents;
  
  // Availability
  final bool isAvailable;
  final DateTime? nextAvailableSlot;
  
  // Additional info
  final String? company;
  final String? linkedIn;
  final String? github;
  final double hourlyRate;

  Expert({
    required this.id,
    required this.name,
    required this.bio,
    this.avatarUrl,
    required this.title,
    required this.skills,
    required this.specializations,
    required this.yearsOfExperience,
    required this.rating,
    required this.totalReviews,
    required this.totalSessions,
    required this.totalStudents,
    this.isAvailable = true,
    this.nextAvailableSlot,
    this.company,
    this.linkedIn,
    this.github,
    required this.hourlyRate,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  bool hasSkill(String skill) {
    return skills.any((s) => s.toLowerCase() == skill.toLowerCase());
  }
}

class ExpertReview {
  final String id;
  final String expertId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String sessionTopic;

  ExpertReview({
    required this.id,
    required this.expertId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.sessionTopic,
  });
}
