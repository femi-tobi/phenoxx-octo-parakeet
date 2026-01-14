import '../models/live_session_model.dart';
import '../models/booking_model.dart';

class LiveSessionService {
  // Singleton pattern
  static final LiveSessionService _instance = LiveSessionService._internal();
  factory LiveSessionService() => _instance;
  LiveSessionService._internal();

  final List<SessionBooking> _userBookings = [];

  // Get all available sessions
  List<LiveSession> getAllSessions() {
    return _mockSessions;
  }

  // Get upcoming sessions (scheduled in the future)
  List<LiveSession> getUpcomingSessions() {
    return _mockSessions
        .where((session) => session.isUpcoming)
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get live sessions (currently ongoing)
  List<LiveSession> getLiveSessions() {
    return _mockSessions.where((session) => session.isLive).toList();
  }

  // Get featured sessions
  List<LiveSession> getFeaturedSessions() {
    return _mockSessions
        .where((session) => session.isUpcoming)
        .take(3)
        .toList();
  }

  // Get sessions by topic
  List<LiveSession> getSessionsByTopic(String topic) {
    if (topic.toLowerCase() == 'all') return getAllSessions();
    return _mockSessions
        .where((session) =>
            session.topic.toLowerCase() == topic.toLowerCase() ||
            session.expertise
                .any((skill) => skill.toLowerCase().contains(topic.toLowerCase())))
        .toList();
  }

  // Get session by ID
  LiveSession? getSessionById(String id) {
    try {
      return _mockSessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search sessions
  List<LiveSession> searchSessions(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockSessions.where((session) {
      return session.title.toLowerCase().contains(lowerQuery) ||
          session.description.toLowerCase().contains(lowerQuery) ||
          session.expertName.toLowerCase().contains(lowerQuery) ||
          session.topic.toLowerCase().contains(lowerQuery) ||
          session.expertise.any((skill) => skill.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Book a session
  SessionBooking? bookSession({
    required String sessionId,
    required String userId,
    String? problemDescription,
    bool notifyOneHourBefore = true,
    bool notifyFifteenMinBefore = true,
    bool notifyEmail = true,
  }) {
    final session = getSessionById(sessionId);
    if (session == null || session.isFull) return null;

    final booking = SessionBooking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      userId: userId,
      sessionTitle: session.title,
      expertName: session.expertName,
      scheduledTime: session.scheduledTime,
      durationMinutes: session.durationMinutes,
      status: BookingStatus.confirmed,
      price: session.price,
      problemDescription: problemDescription,
      topic: session.topic,
      notifyOneHourBefore: notifyOneHourBefore,
      notifyFifteenMinBefore: notifyFifteenMinBefore,
      notifyEmail: notifyEmail,
      bookedAt: DateTime.now(),
    );

    _userBookings.add(booking);
    
    // Update session to mark as booked
    final index = _mockSessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _mockSessions[index] = session.copyWith(
        isBooked: true,
        bookingId: booking.id,
        participantCount: session.participantCount + 1,
      );
    }

    return booking;
  }

  // Cancel booking
  bool cancelBooking(String bookingId) {
    final index = _userBookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) return false;

    final booking = _userBookings[index];
    if (!booking.canCancel) return false;

    _userBookings[index] = booking.copyWith(
      status: BookingStatus.cancelled,
      cancelledAt: DateTime.now(),
    );

    // Update session to remove booking
    final sessionIndex = _mockSessions.indexWhere((s) => s.id == booking.sessionId);
    if (sessionIndex != -1) {
      final session = _mockSessions[sessionIndex];
      _mockSessions[sessionIndex] = session.copyWith(
        isBooked: false,
        bookingId: null,
        participantCount: session.participantCount - 1,
      );
    }

    return true;
  }

  // Get user bookings
  List<SessionBooking> getUserBookings(String userId) {
    return _userBookings.where((b) => b.userId == userId).toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  // Get upcoming bookings
  List<SessionBooking> getUpcomingBookings(String userId) {
    return _userBookings
        .where((b) => b.userId == userId && b.isUpcoming)
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get past bookings
  List<SessionBooking> getPastBookings(String userId) {
    return _userBookings
        .where((b) => b.userId == userId && b.isPast)
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  // Mock data
  final List<LiveSession> _mockSessions = [
    LiveSession(
      id: 'session_1',
      title: 'React Hooks Deep Dive',
      description: 'Master React Hooks including useState, useEffect, useContext, and custom hooks. Learn best practices and common pitfalls.',
      topic: 'React',
      scheduledTime: DateTime.now().add(Duration(hours: 3)),
      durationMinutes: 60,
      expertId: 'expert_1',
      expertName: 'Sarah Chen',
      expertise: ['React', 'JavaScript', 'Frontend'],
      status: SessionStatus.scheduled,
      participantCount: 8,
      maxParticipants: 15,
      price: 29.99,
      learningObjectives: [
        'Understand React Hooks lifecycle',
        'Build custom hooks',
        'Optimize performance with useMemo and useCallback',
      ],
      skillLevel: 'intermediate',
      prerequisites: ['Basic React knowledge', 'JavaScript ES6'],
    ),
    LiveSession(
      id: 'session_2',
      title: 'Python Data Structures Masterclass',
      description: 'Comprehensive guide to Python lists, tuples, dictionaries, sets, and advanced data structures. Solve real coding problems.',
      topic: 'Python',
      scheduledTime: DateTime.now().add(Duration(hours: 24)),
      durationMinutes: 90,
      expertId: 'expert_2',
      expertName: 'Dr. James Wilson',
      expertise: ['Python', 'Data Science', 'Algorithms'],
      status: SessionStatus.scheduled,
      participantCount: 12,
      maxParticipants: 20,
      price: 39.99,
      learningObjectives: [
        'Master Python built-in data structures',
        'Implement custom data structures',
        'Solve algorithm problems efficiently',
      ],
      skillLevel: 'beginner',
      prerequisites: ['Basic Python syntax'],
    ),
    LiveSession(
      id: 'session_3',
      title: 'Flutter State Management with Riverpod',
      description: 'Learn modern state management in Flutter using Riverpod. Build scalable apps with clean architecture.',
      topic: 'Flutter',
      scheduledTime: DateTime.now().add(Duration(hours: 6)),
      durationMinutes: 75,
      expertId: 'expert_3',
      expertName: 'Alex Kumar',
      expertise: ['Flutter', 'Dart', 'Mobile Development'],
      status: SessionStatus.scheduled,
      participantCount: 5,
      maxParticipants: 12,
      price: 34.99,
      learningObjectives: [
        'Understand Riverpod providers',
        'Implement state management patterns',
        'Build reactive UIs',
      ],
      skillLevel: 'intermediate',
      prerequisites: ['Flutter basics', 'Dart knowledge'],
    ),
    LiveSession(
      id: 'session_4',
      title: 'JavaScript Async Programming',
      description: 'Master async/await, Promises, and callbacks. Learn to handle asynchronous operations like a pro.',
      topic: 'JavaScript',
      scheduledTime: DateTime.now().subtract(Duration(minutes: 10)),
      durationMinutes: 60,
      expertId: 'expert_1',
      expertName: 'Sarah Chen',
      expertise: ['JavaScript', 'Node.js', 'Frontend'],
      status: SessionStatus.live,
      participantCount: 18,
      maxParticipants: 20,
      price: 29.99,
      learningObjectives: [
        'Understand event loop',
        'Master Promises and async/await',
        'Handle errors in async code',
      ],
      skillLevel: 'intermediate',
      prerequisites: ['JavaScript basics'],
    ),
    LiveSession(
      id: 'session_5',
      title: 'Git & GitHub Collaboration',
      description: 'Learn Git version control, branching strategies, pull requests, and team collaboration workflows.',
      topic: 'DevOps',
      scheduledTime: DateTime.now().add(Duration(days: 2)),
      durationMinutes: 45,
      expertId: 'expert_4',
      expertName: 'Maria Rodriguez',
      expertise: ['Git', 'DevOps', 'CI/CD'],
      status: SessionStatus.scheduled,
      participantCount: 15,
      maxParticipants: 25,
      price: 19.99,
      learningObjectives: [
        'Master Git commands',
        'Understand branching strategies',
        'Collaborate effectively with teams',
      ],
      skillLevel: 'beginner',
      prerequisites: [],
    ),
    LiveSession(
      id: 'session_6',
      title: 'CSS Grid & Flexbox Layouts',
      description: 'Build modern responsive layouts with CSS Grid and Flexbox. Learn layout patterns used in production.',
      topic: 'CSS',
      scheduledTime: DateTime.now().add(Duration(hours: 12)),
      durationMinutes: 60,
      expertId: 'expert_5',
      expertName: 'Tom Anderson',
      expertise: ['CSS', 'HTML', 'UI Design'],
      status: SessionStatus.scheduled,
      participantCount: 7,
      maxParticipants: 15,
      price: 24.99,
      learningObjectives: [
        'Master CSS Grid layout',
        'Build with Flexbox',
        'Create responsive designs',
      ],
      skillLevel: 'beginner',
      prerequisites: ['Basic HTML/CSS'],
    ),
    LiveSession(
      id: 'session_7',
      title: 'Node.js REST API Development',
      description: 'Build production-ready REST APIs with Node.js, Express, and MongoDB. Learn authentication and best practices.',
      topic: 'Node.js',
      scheduledTime: DateTime.now().add(Duration(days: 1, hours: 6)),
      durationMinutes: 120,
      expertId: 'expert_2',
      expertName: 'Dr. James Wilson',
      expertise: ['Node.js', 'Backend', 'APIs'],
      status: SessionStatus.scheduled,
      participantCount: 10,
      maxParticipants: 15,
      price: 49.99,
      learningObjectives: [
        'Build RESTful APIs',
        'Implement authentication',
        'Connect to databases',
      ],
      skillLevel: 'intermediate',
      prerequisites: ['JavaScript knowledge', 'Basic Node.js'],
    ),
    LiveSession(
      id: 'session_8',
      title: 'Debugging Like a Pro',
      description: 'Master debugging techniques for JavaScript, Python, and Flutter. Use browser DevTools and IDE debuggers effectively.',
      topic: 'General',
      scheduledTime: DateTime.now().add(Duration(hours: 48)),
      durationMinutes: 60,
      expertId: 'expert_3',
      expertName: 'Alex Kumar',
      expertise: ['Debugging', 'Performance', 'Best Practices'],
      status: SessionStatus.scheduled,
      participantCount: 3,
      maxParticipants: 20,
      price: 29.99,
      learningObjectives: [
        'Master debugging tools',
        'Find and fix bugs efficiently',
        'Use breakpoints and console effectively',
      ],
      skillLevel: 'all',
      prerequisites: [],
    ),
  ];
}
