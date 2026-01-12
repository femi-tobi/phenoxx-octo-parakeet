import 'message_model.dart';

class Chat {
  final String id;
  final String name;
  final ChatType type;
  final String? description;
  final List<String> participantIds;
  final List<String> participantNames;
  final Message? lastMessage;
  final int unreadCount;
  final String? avatarUrl;

  Chat({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.participantIds,
    required this.participantNames,
    this.lastMessage,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  Chat copyWith({
    String? id,
    String? name,
    ChatType? type,
    String? description,
    List<String>? participantIds,
    List<String>? participantNames,
    Message? lastMessage,
    int? unreadCount,
    String? avatarUrl,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  bool get isGroup => type == ChatType.group;
  
  String get displayName {
    if (type == ChatType.group) {
      return name;
    }
    // For individual chats, get the other person's name
    return participantNames.isNotEmpty ? participantNames.first : name;
  }
}

enum ChatType {
  individual,
  group,
}
