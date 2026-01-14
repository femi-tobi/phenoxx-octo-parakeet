enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class SessionBooking {
  final String id;
  final String sessionId;
  final String userId;
  final String sessionTitle;
  final String expertName;
  final DateTime scheduledTime;
  final int durationMinutes;
  final BookingStatus status;
  final double price;
  
  // Problem description
  final String? problemDescription;
  final String topic;
  
  // Notifications
  final bool notifyOneHourBefore;
  final bool notifyFifteenMinBefore;
  final bool notifyEmail;
  
  // Timestamps
  final DateTime bookedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  
  // Session notes and recording
  final String? sessionNotes;
  final String? recordingUrl;
  
  // Review
  final bool hasReviewed;
  final double? rating;

  SessionBooking({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.sessionTitle,
    required this.expertName,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.status,
    required this.price,
    this.problemDescription,
    required this.topic,
    this.notifyOneHourBefore = true,
    this.notifyFifteenMinBefore = true,
    this.notifyEmail = true,
    required this.bookedAt,
    this.completedAt,
    this.cancelledAt,
    this.sessionNotes,
    this.recordingUrl,
    this.hasReviewed = false,
    this.rating,
  });

  bool get isUpcoming => status == BookingStatus.confirmed && scheduledTime.isAfter(DateTime.now());
  bool get isPast => status == BookingStatus.completed || scheduledTime.isBefore(DateTime.now());
  bool get canJoin {
    if (status != BookingStatus.confirmed) return false;
    final timeUntil = scheduledTime.difference(DateTime.now());
    return timeUntil.inMinutes <= 15 && timeUntil.inMinutes >= -durationMinutes;
  }
  bool get canCancel => status == BookingStatus.confirmed && scheduledTime.isAfter(DateTime.now());
  bool get canReschedule => status == BookingStatus.confirmed && scheduledTime.isAfter(DateTime.now().add(Duration(hours: 24)));

  Duration get timeUntilStart => scheduledTime.difference(DateTime.now());

  SessionBooking copyWith({
    String? id,
    String? sessionId,
    String? userId,
    String? sessionTitle,
    String? expertName,
    DateTime? scheduledTime,
    int? durationMinutes,
    BookingStatus? status,
    double? price,
    String? problemDescription,
    String? topic,
    bool? notifyOneHourBefore,
    bool? notifyFifteenMinBefore,
    bool? notifyEmail,
    DateTime? bookedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? sessionNotes,
    String? recordingUrl,
    bool? hasReviewed,
    double? rating,
  }) {
    return SessionBooking(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      expertName: expertName ?? this.expertName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      price: price ?? this.price,
      problemDescription: problemDescription ?? this.problemDescription,
      topic: topic ?? this.topic,
      notifyOneHourBefore: notifyOneHourBefore ?? this.notifyOneHourBefore,
      notifyFifteenMinBefore: notifyFifteenMinBefore ?? this.notifyFifteenMinBefore,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      bookedAt: bookedAt ?? this.bookedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      sessionNotes: sessionNotes ?? this.sessionNotes,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      hasReviewed: hasReviewed ?? this.hasReviewed,
      rating: rating ?? this.rating,
    );
  }
}
