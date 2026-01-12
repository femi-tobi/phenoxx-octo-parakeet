import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  // Singleton pattern
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // Mock data
  final List<Chat> _chats = [];
  final Map<String, List<Message>> _messages = {};

  // Current user ID (mock)
  final String currentUserId = 'user_1';

  ChatService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Create mock messages for different chats
    final mentorshipMessages = [
      Message(
        id: 'm1',
        chatId: 'chat_mentorship',
        senderId: 'user_2',
        senderName: 'Sarah Chen',
        content: 'Welcome everyone! Excited to have you all in this mentorship circle 🎉',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'm2',
        chatId: 'chat_mentorship',
        senderId: 'user_3',
        senderName: 'Mike Johnson',
        content: 'Thanks for having us! Looking forward to learning from everyone here.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      Message(
        id: 'm3',
        chatId: 'chat_mentorship',
        senderId: 'user_2',
        senderName: 'Sarah Chen',
        content: 'Our first session will be tomorrow at 3 PM. We\'ll discuss career growth strategies.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];

    final devTeamMessages = [
      Message(
        id: 'm4',
        chatId: 'chat_devteam',
        senderId: 'user_4',
        senderName: 'Alex Kim',
        content: 'Hey team, just pushed the latest updates to the main branch',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      Message(
        id: 'm5',
        chatId: 'chat_devteam',
        senderId: currentUserId,
        senderName: 'You',
        content: 'Great! I\'ll review the PR shortly',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
        isRead: true,
      ),
      Message(
        id: 'm6',
        chatId: 'chat_devteam',
        senderId: 'user_5',
        senderName: 'Emma Davis',
        content: 'Anyone available for a quick sync on the API integration?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
    ];

    final janeMessages = [
      Message(
        id: 'm7',
        chatId: 'chat_jane',
        senderId: 'user_6',
        senderName: 'Jane Cooper',
        content: 'Did you see the latest Python update? Some cool new features!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      Message(
        id: 'm8',
        chatId: 'chat_jane',
        senderId: currentUserId,
        senderName: 'You',
        content: 'Yes! The pattern matching feature looks awesome.',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
        isRead: true,
      ),
      Message(
        id: 'm9',
        chatId: 'chat_jane',
        senderId: 'user_6',
        senderName: 'Jane Cooper',
        content: 'We should try it in our next project',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
    ];

    // Initialize messages map
    _messages['chat_mentorship'] = mentorshipMessages;
    _messages['chat_devteam'] = devTeamMessages;
    _messages['chat_jane'] = janeMessages;

    // Create mock chats
    _chats.addAll([
      Chat(
        id: 'chat_mentorship',
        name: 'Flutter Mentorship Circle',
        type: ChatType.group,
        description: 'Connect with senior devs & accelerate your career',
        participantIds: ['user_1', 'user_2', 'user_3', 'user_7', 'user_8'],
        participantNames: ['You', 'Sarah Chen', 'Mike Johnson', 'David Lee', 'Anna Wilson'],
        lastMessage: mentorshipMessages.last,
        unreadCount: 1,
      ),
      Chat(
        id: 'chat_devteam',
        name: 'Dev Team - Project X',
        type: ChatType.group,
        description: 'Main development team chat',
        participantIds: ['user_1', 'user_4', 'user_5', 'user_9'],
        participantNames: ['You', 'Alex Kim', 'Emma Davis', 'Chris Park'],
        lastMessage: devTeamMessages.last,
        unreadCount: 1,
      ),
      Chat(
        id: 'chat_jane',
        name: 'Jane Cooper',
        type: ChatType.individual,
        participantIds: ['user_1', 'user_6'],
        participantNames: ['Jane Cooper'],
        lastMessage: janeMessages.last,
        unreadCount: 1,
      ),
      Chat(
        id: 'chat_python',
        name: 'Python Developers',
        type: ChatType.group,
        description: 'All things Python',
        participantIds: ['user_1', 'user_10', 'user_11', 'user_12'],
        participantNames: ['You', 'Tom Brown', 'Lisa White', 'Kevin Zhang'],
        lastMessage: null,
        unreadCount: 0,
      ),
    ]);
  }

  // Get all chats
  List<Chat> getChats() {
    return List.from(_chats)..sort((a, b) {
      if (a.lastMessage == null && b.lastMessage == null) return 0;
      if (a.lastMessage == null) return 1;
      if (b.lastMessage == null) return -1;
      return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
    });
  }

  // Get messages for a specific chat
  List<Message> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  // Get chat by ID
  Chat? getChatById(String chatId) {
    try {
      return _chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }

  // Send a message
  void sendMessage(String chatId, String content) {
    final newMessage = Message(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: currentUserId,
      senderName: 'You',
      content: content,
      timestamp: DateTime.now(),
      isRead: true,
    );

    // Add to messages
    if (_messages[chatId] != null) {
      _messages[chatId]!.add(newMessage);
    } else {
      _messages[chatId] = [newMessage];
    }

    // Update chat's last message
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(lastMessage: newMessage);
    }
  }

  // Mark chat as read
  void markChatAsRead(String chatId) {
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(unreadCount: 0);
    }
    
    // Mark all messages as read
    if (_messages[chatId] != null) {
      _messages[chatId] = _messages[chatId]!.map((msg) {
        if (msg.senderId != currentUserId) {
          return msg.copyWith(isRead: true);
        }
        return msg;
      }).toList();
    }
  }

  // Get total unread count
  int getTotalUnreadCount() {
    return _chats.fold(0, (sum, chat) => sum + chat.unreadCount);
  }

  // Create a new group chat (e.g., from mentorship circle)
  Chat createGroupChat({
    required String name,
    required String description,
    required List<String> participantIds,
    required List<String> participantNames,
  }) {
    final newChat = Chat(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: ChatType.group,
      description: description,
      participantIds: participantIds,
      participantNames: participantNames,
      unreadCount: 0,
    );

    _chats.add(newChat);
    _messages[newChat.id] = [];

    return newChat;
  }
}
