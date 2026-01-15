enum RewardSource { 
  task_completion, 
  project_milestone, 
  session_attendance, 
  peer_review, 
  quiz_completion,
  daily_streak,
  referral,
}

enum RewardStatus { 
  pending, 
  verified, 
  redeemed, 
  rejected, 
  expired,
}

class DataReward {
  final String id;
  final double dataMB;
  final String userId;
  final RewardSource source;
  final String sourceId; // Task ID, Project ID, etc.
  final DateTime earnedAt;
  final RewardStatus status;
  final DateTime? redeemedAt;
  final DateTime? expiresAt;

  // Security - prevent fraud
  final String verificationHash; // SHA-256 proof
  final List<String> witnessIds; // Multi-sig verification (for high-value rewards)
  final bool isVerifiedByAdmin;
  final String? rejectionReason;

  DataReward({
    required this.id,
    required this.dataMB,
    required this.userId,
    required this.source,
    required this.sourceId,
    required this.earnedAt,
    this.status = RewardStatus.pending,
    this.redeemedAt,
    this.expiresAt,
    required this.verificationHash,
    this.witnessIds = const [],
    this.isVerifiedByAdmin = false,
    this.rejectionReason,
  });

  bool get isPending => status == RewardStatus.pending;
  bool get isVerified => status == RewardStatus.verified;
  bool get isRedeemed => status == RewardStatus.redeemed;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  String get sourceLabel {
    switch (source) {
      case RewardSource.task_completion:
        return 'Task Completed';
      case RewardSource.project_milestone:
        return 'Project Milestone';
      case RewardSource.session_attendance:
        return 'Session Attendance';
      case RewardSource.peer_review:
        return 'Peer Review';
      case RewardSource.quiz_completion:
        return 'Quiz Completed';
      case RewardSource.daily_streak:
        return 'Daily Streak';
      case RewardSource.referral:
        return 'Referral Bonus';
    }
  }

  DataReward copyWith({
    RewardStatus? status,
    DateTime? redeemedAt,
    bool? isVerifiedByAdmin,
    String? rejectionReason,
  }) {
    return DataReward(
      id: id,
      dataMB: dataMB,
      userId: userId,
      source: source,
      sourceId: sourceId,
      earnedAt: earnedAt,
      status: status ?? this.status,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      expiresAt: expiresAt,
      verificationHash: verificationHash,
      witnessIds: witnessIds,
      isVerifiedByAdmin: isVerifiedByAdmin ?? this.isVerifiedByAdmin,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

class DataBalance {
  final String userId;
  final double totalEarnedMB;
  final double redeemedMB;
  final double pendingMB;
  final double availableMB;
  final List<DataReward> recentRewards;
  final DateTime lastUpdated;

  // Fraud prevention
  final int dailyEarnLimitMB;
  final int monthlyEarnLimitMB;
  final double todayEarnedMB;
  final double monthEarnedMB;
  final bool isSuspended;
  final String? suspensionReason;
  final DateTime? suspensionUntil;

  // Analytics
  final int totalRedemptions;
  final int currentStreak; // Days
  final int longestStreak;

  DataBalance({
    required this.userId,
    required this.totalEarnedMB,
    required this.redeemedMB,
    required this.pendingMB,
    required this.availableMB,
    required this.recentRewards,
    required this.lastUpdated,
    this.dailyEarnLimitMB = 500,
    this.monthlyEarnLimitMB = 5000,
    required this.todayEarnedMB,
    required this.monthEarnedMB,
    this.isSuspended = false,
    this.suspensionReason,
    this.suspensionUntil,
    this.totalRedemptions = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  bool get canEarnToday => todayEarnedMB < dailyEarnLimitMB;
  bool get canEarnThisMonth => monthEarnedMB < monthlyEarnLimitMB;
  bool get hasAvailableData => availableMB > 0;
  
  double get remainingDailyLimit => dailyEarnLimitMB - todayEarnedMB;
  double get remainingMonthlyLimit => monthlyEarnLimitMB - monthEarnedMB;
}

class DataTransaction {
  final String id;
  final String userId;
  final double dataMB;
  final TransactionType type;
  final DateTime timestamp;
  final String description;
  final String? rewardId;
  final String? referenceNumber; // Carrier transaction ref

  DataTransaction({
    required this.id,
    required this.userId,
    required this.dataMB,
    required this.type,
    required this.timestamp,
    required this.description,
    this.rewardId,
    this.referenceNumber,
  });
}

enum TransactionType { 
  earned, 
  redeemed, 
  expired, 
  cancelled,
  bonus,
}

class MobileCarrier {
  final String id;
  final String name;
  final String logoUrl;
  final List<DataPackage> packages;
  final bool isActive;

  MobileCarrier({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.packages,
    this.isActive = true,
  });
}

class DataPackage {
  final String id;
  final String name;
  final double dataMB;
  final int validityDays;
  final String description;

  DataPackage({
    required this.id,
    required this.name,
    required this.dataMB,
    required this.validityDays,
    required this.description,
  });

  String get dataDisplay {
    if (dataMB >= 1024) {
      return '${(dataMB / 1024).toStringAsFixed(1)}GB';
    }
    return '${dataMB.toInt()}MB';
  }
}
