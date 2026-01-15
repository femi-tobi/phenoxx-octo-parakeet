import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Security service for encryption, hashing, and secure data handling
/// TODO Backend: Replace with server-side encryption for production
class EncryptionService {
  // Singleton pattern
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // AES-256 encryption key (In production, this should come from secure backend)
  final _key = encrypt.Key.fromLength(32);
  final _iv = encrypt.IV.fromLength(16);

  /// Encrypt sensitive data using AES-256
  /// Used for: invite codes, private messages, user data
  String encryptData(String plainText) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final encrypted = encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Encryption error: $e');
      return '';
    }
  }

  /// Decrypt AES-256 encrypted data
  String decryptData(String encryptedText) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return '';
    }
  }

  /// Generate SHA-256 hash for verification
  /// Used for: data rewards, task verification, credential verification
  String generateHash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify hash matches input
  bool verifyHash(String input, String hash) {
    return generateHash(input) == hash;
  }

  /// Generate secure random token
  /// Used for: invite codes, API tokens, session IDs
  String generateToken(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = encrypt.SecureRandom(length);
    final bytes = random.bytes;
    return String.fromCharCodes(
      List.generate(length, (index) => chars.codeUnitAt(bytes[index % bytes.length] % chars.length)),
    );
  }

  /// Generate invite code for groups (6-char alphanumeric)
  String generateInviteCode() {
    return generateToken(6).toUpperCase();
  }

  /// Hash password using SHA-256 (In production, use bcrypt on backend)
  /// TODO Backend: Implement bcrypt/argon2 password hashing
  String hashPassword(String password) {
    final salted = '$password:phenoxx_salt_${DateTime.now().millisecondsSinceEpoch}';
    return generateHash(salted);
  }

  /// Generate verification code for 2FA (6-digit)
  String generate2FACode() {
    final random = encrypt.SecureRandom(6);
    final bytes = random.bytes;
    return List.generate(6, (i) => bytes[i %bytes.length] % 10).join();
  }

  /// Create digital signature for tasks/rewards
  /// TODO Backend: Implement proper RSA digital signatures
  String createSignature(String data, String userId) {
    final timestamp = DateTime.now().toIso8601String();
    final payload = '$data:$userId:$timestamp';
    return generateHash(payload);
  }

  /// Verify digital signature
  bool verifySignature(String data, String signature, String userId) {
    // In mock, just verify hash format
    return signature.length == 64; // SHA-256 length
  }

  /// Encrypt file for DRM (offline content)
  /// TODO Backend: Implement proper DRM with license server
  List<int> encryptFile(List<int> fileBytes) {
    // Mock implementation - just return bytes
    // In production, use AES file encryption
    return fileBytes;
  }

  /// Decrypt DRM file
  List<int> decryptFile(List<int> encryptedBytes) {
    // Mock implementation
    return encryptedBytes;
  }

  /// Sanitize user input to prevent XSS
  String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Check password strength
  /// Returns: [isStrong, message]
  Map<String, dynamic> checkPasswordStrength(String password) {
    if (password.length < 8) {
      return {'isStrong': false, 'message': 'Password must be at least 8 characters'};
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return {'isStrong': false, 'message': 'Password must contain uppercase letter'};
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return {'isStrong': false, 'message': 'Password must contain lowercase letter'};
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return {'isStrong': false, 'message': 'Password must contain number'};
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return {'isStrong': false, 'message': 'Password must contain special character'};
    }
    return {'isStrong': true, 'message': 'Strong password'};
  }
}
