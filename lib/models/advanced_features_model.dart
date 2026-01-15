enum DebugStatus { analyzing, suggestions_ready, resolved, failed }

enum SeverityLevel { info, warning, error, critical }

class DebugSession {
  final String id;
  final String userId;
  final String code;
  final String language;
  final String errorMessage;
  final List<AISuggestion> suggestions;
  final DebugStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  // Security - prevent abuse
  final bool isCodeSandboxed;
  final int tokenLimit;
  final bool isCodeFiltered;

  DebugSession({
    required this.id,
    required this.userId,
    required this.code,
    required this.language,
    required this.errorMessage,
    this.suggestions = const [],
    this.status = DebugStatus.analyzing,
    required this.createdAt,
    this.resolvedAt,
    this.isCodeSandboxed = true,
    this.tokenLimit = 2000,
    this.isCodeFiltered = true,
  });
}

class AISuggestion {
  final String id;
  final String issue;
  final String explanation;
  final String suggestedFix;
  final int? lineNumber;
  final SeverityLevel severity;
  final List<String> relatedDocs;
  final double confidence; // 0-100%

  AISuggestion({
    required this.id,
    required this.issue,
    required this.explanation,
    required this.suggestedFix,
    this.lineNumber,
    required this.severity,
    this.relatedDocs = const [],
    required this.confidence,
  });
}

// Offline Learning Models
enum ContentType { video, pdf, code_lab, quiz, article }

enum DownloadStatus { pending, downloading, paused, completed, failed }

class OfflineContent {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final String downloadUrl;
  final int fileSizeMB;
  final bool isDownloaded;
  final String? localPath;
  final DateTime? downloadedAt;
  final DownloadStatus downloadStatus;
  final double downloadProgress; // 0-100

  // Security - DRM for premium content
  final bool requiresEncryption;
  final String? encryptionKey;
  final DateTime? licenseExpiry;
  final bool isPremium;

  OfflineContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.downloadUrl,
    required this.fileSizeMB,
    this.isDownloaded = false,
    this.localPath,
    this.downloadedAt,
    this.downloadStatus = DownloadStatus.pending,
    this.downloadProgress = 0,
    this.requiresEncryption = false,
    this.encryptionKey,
    this.licenseExpiry,
    this.isPremium = false,
  });

  bool get isExpired => licenseExpiry != null && DateTime.now().isAfter(licenseExpiry!);
}

// Blockchain Credentials
class BlockchainCredential {
  final String id;
  final String userId;
  final String skillName;
  final SkillLevel level;
  final String issuerOrganization;
  final DateTime issuedAt;

  // Blockchain data
  final String blockchainTxHash;
  final String contractAddress;
  final String nftTokenId;
  final String ipfsMetadataUrl;
  final String walletAddress;

  // Verification
  final bool isVerified;
  final List<String> verifierSignatures;
  final String credentialHash;
  final List<String> proofOfWork; // Project IDs, test scores

  BlockchainCredential({
    required this.id,
    required this.userId,
    required this.skillName,
    required this.level,
    required this.issuerOrganization,
    required this.issuedAt,
    required this.blockchainTxHash,
    required this.contractAddress,
    required this.nftTokenId,
    required this.ipfsMetadataUrl,
    required this.walletAddress,
    this.isVerified = false,
    this.verifierSignatures = const [],
    required this.credentialHash,
    this.proofOfWork = const [],
  });
}

enum SkillLevel { beginner, intermediate, advanced, expert }

// Portfolio
class Portfolio {
  final String userId;
  final String displayName;
  final String bio;
  final String? avatarUrl;
  final List<ProjectShowcase> projects;
  final List<SkillBadge> skills;
  final List<BlockchainCredential> credentials;
  final List<Testimonial> testimonials;
  final String? githubUsername;
  final String? linkedInUrl;

  // Auto-generated content
  final String aiGeneratedSummary;
  final List<String> topSkills;
  final Map<String, int> skillLevels;

  // Sharing & Security
  final String publicShareUrl;
  final bool isPublic;
  final int viewCount;
  final DateTime lastUpdated;

  Portfolio({
    required this.userId,
    required this.displayName,
    required this.bio,
    this.avatarUrl,
    required this.projects,
    required this.skills,
    required this.credentials,
    required this.testimonials,
    this.githubUsername,
    this.linkedInUrl,
    required this.aiGeneratedSummary,
    required this.topSkills,
    required this.skillLevels,
    required this.publicShareUrl,
    this.isPublic = false,
    this.viewCount = 0,
    required this.lastUpdated,
  });
}

class ProjectShowcase {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? thumbnailUrl;
  final String? liveUrl;
  final String? githubUrl;
  final DateTime completedAt;

  ProjectShowcase({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.thumbnailUrl,
    this.liveUrl,
    this.githubUrl,
    required this.completedAt,
  });
}

class SkillBadge {
  final String skillName;
  final int proficiency; // 0-100
  final String? iconUrl;
  final int projectCount;

  SkillBadge({
    required this.skillName,
    required this.proficiency,
    this.iconUrl,
    required this.projectCount,
  });
}

class Testimonial {
  final String id;
  final String authorName;
  final String authorTitle;
  final String content;
  final DateTime createdAt;

  Testimonial({
    required this.id,
    required this.authorName,
    required this.authorTitle,
    required this.content,
    required this.createdAt,
  });
}
