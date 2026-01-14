import '../models/expert_model.dart';

class ExpertService {
  // Singleton pattern
  static final ExpertService _instance = ExpertService._internal();
  factory ExpertService() => _instance;
  ExpertService._internal();

  // Get all experts
  List<Expert> getAllExperts() {
    return _mockExperts;
  }

  // Get expert by ID
  Expert? getExpertById(String id) {
    try {
      return _mockExperts.firstWhere((expert) => expert.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get experts by skill
  List<Expert> getExpertsBySkill(String skill) {
    return _mockExperts
        .where((expert) => expert.hasSkill(skill))
        .toList();
  }

  // Get top rated experts
  List<Expert> getTopRatedExperts() {
    return _mockExperts
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Get available experts
  List<Expert> getAvailableExperts() {
    return _mockExperts.where((expert) => expert.isAvailable).toList();
  }

  // Search experts
  List<Expert> searchExperts(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockExperts.where((expert) {
      return expert.name.toLowerCase().contains(lowerQuery) ||
          expert.bio.toLowerCase().contains(lowerQuery) ||
          expert.title.toLowerCase().contains(lowerQuery) ||
          expert.skills.any((skill) => skill.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get reviews for an expert
  List<ExpertReview> getExpertReviews(String expertId) {
    return _mockReviews
        .where((review) => review.expertId == expertId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Mock experts data
  final List<Expert> _mockExperts = [
    Expert(
      id: 'expert_1',
      name: 'Sarah Chen',
      bio: 'Senior Full-Stack Developer with 8+ years at Google. Passionate about teaching React and modern web development.',
      title: 'Senior Full-Stack Developer',
      skills: ['React', 'JavaScript', 'TypeScript', 'Node.js', 'Frontend'],
      specializations: ['React Ecosystem', 'Performance Optimization', 'Web Architecture'],
      yearsOfExperience: 8,
      rating: 4.9,
      totalReviews: 147,
      totalSessions: 230,
      totalStudents: 450,
      isAvailable: true,
      company: 'Google',
      hourlyRate: 75.0,
    ),
    Expert(
      id: 'expert_2',
      name: 'Dr. James Wilson',
      bio: 'PhD in Computer Science. Former professor turned industry expert. Specializing in Python, algorithms, and data science.',
      title: 'Senior Data Scientist',
      skills: ['Python', 'Data Science', 'Machine Learning', 'Algorithms', 'SQL'],
      specializations: ['Python Programming', 'Data Analysis', 'Algorithm Design'],
      yearsOfExperience: 12,
      rating: 4.8,
      totalReviews: 203,
      totalSessions: 310,
      totalStudents: 620,
      isAvailable: true,
      company: 'Microsoft',
      hourlyRate: 85.0,
    ),
    Expert(
      id: 'expert_3',
      name: 'Alex Kumar',
      bio: 'Mobile development expert with focus on Flutter and React Native. Built 50+ production apps for startups and enterprises.',
      title: 'Lead Mobile Developer',
      skills: ['Flutter', 'Dart', 'React Native', 'Mobile Development', 'Firebase'],
      specializations: ['Flutter Development', 'State Management', 'Mobile Architecture'],
      yearsOfExperience: 6,
      rating: 4.9,
      totalReviews: 128,
      totalSessions: 185,
      totalStudents: 340,
      isAvailable: true,
      company: 'Uber',
      hourlyRate: 70.0,
    ),
    Expert(
      id: 'expert_4',
      name: 'Maria Rodriguez',
      bio: 'DevOps engineer and Git expert. I help teams streamline their development workflow and master version control.',
      title: 'DevOps Engineer',
      skills: ['Git', 'DevOps', 'CI/CD', 'Docker', 'Kubernetes', 'AWS'],
      specializations: ['Version Control', 'Continuous Integration', 'Cloud Infrastructure'],
      yearsOfExperience: 7,
      rating: 4.7,
      totalReviews: 95,
      totalSessions: 160,
      totalStudents: 280,
      isAvailable: true,
      company: 'Netflix',
      hourlyRate: 80.0,
    ),
    Expert(
      id: 'expert_5',
      name: 'Tom Anderson',
      bio: 'UI/UX designer and CSS expert. I teach developers how to build beautiful, responsive interfaces that users love.',
      title: 'Senior UI/UX Developer',
      skills: ['CSS', 'HTML', 'UI Design', 'Responsive Design', 'Tailwind CSS'],
      specializations: ['Modern CSS', 'Layout Design', 'Animation'],
      yearsOfExperience: 9,
      rating: 4.8,
      totalReviews: 112,
      totalSessions: 195,
      totalStudents: 380,
      isAvailable: true,
      company: 'Adobe',
      hourlyRate: 65.0,
    ),
  ];

  // Mock reviews data
  final List<ExpertReview> _mockReviews = [
    ExpertReview(
      id: 'review_1',
      expertId: 'expert_1',
      userId: 'user_1',
      userName: 'John Doe',
      rating: 5.0,
      comment: 'Sarah is an amazing teacher! She explained React hooks in a way that finally made sense to me. Highly recommend!',
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      sessionTopic: 'React Hooks',
    ),
    ExpertReview(
      id: 'review_2',
      expertId: 'expert_1',
      userId: 'user_2',
      userName: 'Emily Zhang',
      rating: 5.0,
      comment: 'Best session I\'ve had. Sarah is patient and really knows her stuff. Will book again!',
      createdAt: DateTime.now().subtract(Duration(days: 12)),
      sessionTopic: 'JavaScript Async',
    ),
    ExpertReview(
      id: 'review_3',
      expertId: 'expert_2',
      userId: 'user_3',
      userName: 'David Kim',
      rating: 5.0,
      comment: 'Dr. Wilson makes complex algorithms easy to understand. Great session!',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      sessionTopic: 'Python Algorithms',
    ),
    ExpertReview(
      id: 'review_4',
      expertId: 'expert_3',
      userId: 'user_4',
      userName: 'Lisa Brown',
      rating: 5.0,
      comment: 'Alex helped me debug my Flutter app and taught me best practices. Super helpful!',
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      sessionTopic: 'Flutter Debugging',
    ),
    ExpertReview(
      id: 'review_5',
      expertId: 'expert_3',
      userId: 'user_5',
      userName: 'Michael Johnson',
      rating: 4.0,
      comment: 'Great session on state management. Would have liked more time for Q&A though.',
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      sessionTopic: 'Flutter State Management',
    ),
  ];
}
