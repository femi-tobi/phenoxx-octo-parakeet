import 'package:phenoxx/models/data_reward_model.dart';
import 'package:phenoxx/services/encryption_service.dart';

/// Service for managing data rewards with fraud detection
/// TODO Backend: Replace with API calls to /api/data-rewards
class DataRewardService {
  static final DataRewardService _instance = DataRewardService._internal();
  factory DataRewardService() => _instance;
  DataRewardService._internal();

  final EncryptionService _encryption = EncryptionService();

  // Mock data
  final List<DataReward> _mockRewards = [];
  final List<DataTransaction> _mockTransactions = [];
  final List<MobileCarrier> _mockCarriers = [];

  DataRewardService._() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock carriers
    _mockCarriers.addAll([
      MobileCarrier(
        id: 'mtn',
        name: 'MTN Nigeria',
        logoUrl: 'assets/mtn_logo.png',
        packages: [
          DataPackage(
            id: 'mtn_100',
            name: '100MB Bundle',
            dataMB: 100,
            validityDays: 1,
            description: '100MB valid for 1 day',
          ),
          DataPackage(
            id: 'mtn_500',
            name: '500MB Bundle',
            dataMB: 500,
            validityDays: 3,
            description: '500MB valid for 3 days',
          ),
          DataPackage(
            id: 'mtn_1gb',
            name: '1GB Bundle',
            dataMB: 1024,
            validityDays: 7,
            description: '1GB valid for 7 days',
          ),
        ],
      ),
      MobileCarrier(
        id: 'glo',
        name: 'Glo Mobile',
        logoUrl: 'assets/glo_logo.png',
        packages: [
          DataPackage(
            id: 'glo_100',
            name: '100MB Plan',
            dataMB: 100,
            validityDays: 1,
            description: '100MB for 1 day',
          ),
          DataPackage(
            id: 'glo_500',
            name: '500MB Plan',
            dataMB: 500,
            validityDays: 5,
            description: '500MB for 5 days',
          ),
        ],
      ),
      MobileCarrier(
        id: 'airtel',
        name: 'Airtel',
        logoUrl: 'assets/airtel_logo.png',
        packages: [
          DataPackage(
            id: 'airtel_100',
            name: '100MB Data',
            dataMB: 100,
            validityDays: 1,
            description: '100MB daily plan',
          ),
          DataPackage(
            id: 'airtel_1gb',
            name: '1GB Data',
            dataMB: 1024,
            validityDays: 7,
            description: '1GB weekly plan',
          ),
        ],
      ),
    ]);

    // Mock rewards for current user
    _mockRewards.addAll([
      DataReward(
        id: 'reward_1',
        dataMB: 50,
        userId: 'current_user',
        source: RewardSource.task_completion,
        sourceId: 'task_123',
        earnedAt: DateTime.now().subtract(const Duration(days: 2)),
        status: RewardStatus.verified,
        verificationHash: _encryption.generateHash('task_123:current_user'),
        isVerifiedByAdmin: true,
      ),
      DataReward(
        id: 'reward_2',
        dataMB: 100,
        userId: 'current_user',
        source: RewardSource.project_milestone,
        sourceId: 'project_456',
        earnedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: RewardStatus.verified,
        verificationHash: _encryption.generateHash('project_456:current_user'),
        isVerifiedByAdmin: true,
      ),
      DataReward(
        id: 'reward_3',
        dataMB: 25,
        userId: 'current_user',
        source: RewardSource.session_attendance,
        sourceId: 'session_789',
        earnedAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: RewardStatus.pending,
        verificationHash: _encryption.generateHash('session_789:current_user'),
      ),
      DataReward(
        id: 'reward_4',
        dataMB: 75,
        userId: 'current_user',
        source: RewardSource.daily_streak,
        sourceId: 'streak_7',
        earnedAt: DateTime.now(),
        status: RewardStatus.verified,
        verificationHash: _encryption.generateHash('streak_7:current_user'),
        isVerifiedByAdmin: true,
      ),
    ]);

    // Mock transactions
    _mockTransactions.addAll([
      DataTransaction(
        id: 'txn_1',
        userId: 'current_user',
        dataMB: 100,
        type: TransactionType.redeemed,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Redeemed 100MB to MTN',
        referenceNumber: 'MTN12345',
      ),
      DataTransaction(
        id: 'txn_2',
        userId: 'current_user',
        dataMB: 50,
        type: TransactionType.earned,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Completed coding task',
        rewardId: 'reward_1',
      ),
    ]);
  }

  /// Get user's data balance
  /// TODO Backend: GET /api/data-rewards/balance/{userId}
  DataBalance getBalance(String userId) {
    final userRewards = _mockRewards.where((r) => r.userId == userId).toList();
    
    final totalEarned = userRewards
        .where((r) => r.status == RewardStatus.verified || r.status == RewardStatus.redeemed)
        .fold(0.0, (sum, r) => sum + r.dataMB);
    
    final redeemed = userRewards
        .where((r) => r.status == RewardStatus.redeemed)
        .fold(0.0, (sum, r) => sum + r.dataMB);
    
    final pending = userRewards
        .where((r) => r.status == RewardStatus.pending)
        .fold(0.0, (sum, r) => sum + r.dataMB);
    
    final available = totalEarned - redeemed;

    // Today's earnings (for daily limit check)
    final today = DateTime.now();
    final todayEarned = userRewards
        .where((r) => 
          r.earnedAt.year == today.year &&
          r.earnedAt.month == today.month &&
          r.earnedAt.day == today.day)
        .fold(0.0, (sum, r) => sum + r.dataMB);

    return DataBalance(
      userId: userId,
      totalEarnedMB: totalEarned,
      redeemedMB: redeemed,
      pendingMB: pending,
      availableMB: available,
      recentRewards: userRewards.take(5).toList(),
      lastUpdated: DateTime.now(),
      todayEarnedMB: todayEarned,
      monthEarnedMB: totalEarned, // Simplified for mock
      currentStreak: 7,
      longestStreak: 12,
      totalRedemptions: 3,
    );
  }

  /// Award data for completing a task/activity
  /// TODO Backend: POST /api/data-rewards/award
  /// Body: { userId, dataMB, source, sourceId }
  DataReward? awardData({
    required String userId,
    required double dataMB,
    required RewardSource source,
    required String sourceId,
  }) {
    // Check daily limit
    final balance = getBalance(userId);
    if (!balance.canEarnToday) {
      print('Daily limit reached');
      return null;
    }

    // Check if already rewarded for this source
    final existing = _mockRewards.where(
      (r) => r.sourceId == sourceId && r.userId == userId,
    );
    if (existing.isNotEmpty) {
      print('Already rewarded for this activity');
      return null;
    }

    // Generate verification hash
    final hash = _encryption.createSignature('$sourceId:$userId', userId);

    // Create reward (pending verification)
    final reward = DataReward(
      id: 'reward_${DateTime.now().millisecondsSinceEpoch}',
      dataMB: dataMB,
      userId: userId,
      source: source,
      sourceId: sourceId,
      earnedAt: DateTime.now(),
      status: dataMB > 100 ? RewardStatus.pending : RewardStatus.verified,
      verificationHash: hash,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      isVerifiedByAdmin: dataMB <= 100, // Auto-verify small amounts
    );

    _mockRewards.add(reward);

    // Add transaction
    _mockTransactions.add(DataTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      dataMB: dataMB,
      type: TransactionType.earned,
      timestamp: DateTime.now(),
      description: 'Earned from ${reward.sourceLabel}',
      rewardId: reward.id,
    ));

    return reward;
  }

  /// Redeem data to mobile carrier
  /// TODO Backend: POST /api/data-rewards/redeem
  /// Body: { userId, dataMB, carrierId, phoneNumber }
  Future<Map<String, dynamic>> redeemData({
    required String userId,
    required double dataMB,
    required String carrierId,
    required String phoneNumber,
  }) async {
    final balance = getBalance(userId);

    if (balance.isSuspended) {
      return {'success': false, 'error': 'Account suspended: ${balance.suspensionReason}'};
    }

    if (!balance.hasAvailableData || balance.availableMB < dataMB) {
      return {'success': false, 'error': 'Insufficient data balance'};
    }

    // Simulate API call to carrier
    await Future.delayed(const Duration(seconds: 2));

    // Mark rewards as redeemed (FIFO)
    double remaining = dataMB;
    for (final reward in _mockRewards.where((r) => 
      r.userId == userId && r.status == RewardStatus.verified)) {
      if (remaining <= 0) break;
      
      final toRedeem = remaining >= reward.dataMB ? reward.dataMB : remaining;
      final index = _mockRewards.indexOf(reward);
      _mockRewards[index] = reward.copyWith(
        status: RewardStatus.redeemed,
        redeemedAt: DateTime.now(),
      );
      remaining -= toRedeem;
    }

    // Add transaction
    final refNumber = 'REF${DateTime.now().millisecondsSinceEpoch}';
    _mockTransactions.add(DataTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      dataMB: dataMB,
      type: TransactionType.redeemed,
      timestamp: DateTime.now(),
      description: 'Redeemed to $carrierId',
      referenceNumber: refNumber,
    ));

    return {
      'success': true,
      'referenceNumber': refNumber,
      'message': '${dataMB.toInt()}MB sent to $phoneNumber',
    };
  }

  /// Get available carriers
  /// TODO Backend: GET /api/data-rewards/carriers
  List<MobileCarrier> getCarriers() {
    return _mockCarriers.where((c) => c.isActive).toList();
  }

  /// Get transaction history
  /// TODO Backend: GET /api/data-rewards/transactions/{userId}
  List<DataTransaction> getTransactions(String userId) {
    return _mockTransactions
        .where((t) => t.userId == userId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get pending rewards (for admin verification)
  /// TODO Backend: GET /api/data-rewards/pending
  List<DataReward> getPendingRewards() {
    return _mockRewards.where((r) => r.isPending).toList();
  }
}
