enum SessionStatus {
  scheduled,
  live,
  completed,
  cancelled,
}

class LiveSession {
  final String id;
  final String title;
  final String description;
  final String topic;
  final DateTime scheduledTime;
  final int durationMinutes;
  
  // Expert information
  final String expertId;
  final String expertName;
  final String? expertAvatar;
  final List<String> expertise;
  
  // Session details
  final SessionStatus status;
  final int participantCount;
  final int maxParticipants;
  
  // Booking information
  final bool isBooked;
  final String? bookingId;
  final double price;
  
  // Additional info
  final List<String> learningObjectives;
  final String skillLevel; // beginner, intermediate, advanced
  final List<String> prerequisites;

  LiveSession({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.expertId,
    required this.expertName,
    this.expertAvatar,
    required this.expertise,
    required this.status,
    required this.participantCount,
    required this.maxParticipants,
    this.isBooked = false,
    this.bookingId,
    required this.price,
    required this.learningObjectives,
    this.skillLevel = 'beginner',
    this.prerequisites = const [],
  });

  bool get isFull => participantCount >= maxParticipants;
  bool get isLive => status == SessionStatus.live;
  bool get isUpcoming => status == SessionStatus.scheduled && scheduledTime.isAfter(DateTime.now());
  int get spotsLeft => maxParticipants - participantCount;
  
  Duration get timeUntilStart => scheduledTime.difference(DateTime.now());
  bool get canJoin => isBooked && (isLive || timeUntilStart.inMinutes <= 15 && timeUntilStart.inMinutes >= 0);

  LiveSession copyWith({
    String? id,
    String? title,
    String? description,
    String? topic,
    DateTime? scheduledTime,
    int? durationMinutes,
    String? expertId,
    String? expertName,
    String? expertAvatar,
    List<String>? expertise,
    SessionStatus? status,
    int? participantCount,
    int? maxParticipants,
    bool? isBooked,
    String? bookingId,
    double? price,
    List<String>? learningObjectives,
    String? skillLevel,
    List<String>? prerequisites,
  }) {
    return LiveSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      expertId: expertId ?? this.expertId,
      expertName: expertName ?? this.expertName,
      expertAvatar: expertAvatar ?? this.expertAvatar,
      expertise: expertise ?? this.expertise,
      status: status ?? this.status,
      participantCount: participantCount ?? this.participantCount,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isBooked: isBooked ?? this.isBooked,
      bookingId: bookingId ?? this.bookingId,
      price: price ?? this.price,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      skillLevel: skillLevel ?? this.skillLevel,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }
}
