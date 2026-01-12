import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/chat_model.dart';
import 'services/chat_service.dart';
import 'chat_conversation_screen.dart';
import 'contact_search_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ChatService _chatService = ChatService();
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    setState(() {
      _chats = _chatService.getChats();
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ChatSearchDelegate(_chats),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {
              _showMenuOptions(context);
            },
          ),
        ],
      ),
      body: _chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No chats yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation or join a group',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return _buildChatItem(context, chat, isDark);
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'chats_fab',
        onPressed: () {
          _showNewChatDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Chat chat, bool isDark) {
    final hasUnread = chat.unreadCount > 0;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationScreen(chat: chat),
          ),
        ).then((_) => _loadChats());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: chat.isGroup ? Colors.blue : _getAvatarColor(chat.id),
                  child: chat.isGroup
                      ? const Icon(Icons.groups, color: Colors.white, size: 28)
                      : Text(
                          chat.displayName[0].toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.lastMessage != null)
                        Text(
                          _formatTimestamp(chat.lastMessage!.timestamp),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: hasUnread ? Colors.blue : Colors.grey[500],
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (chat.lastMessage != null)
                    Text(
                      chat.lastMessage!.senderId == _chatService.currentUserId
                          ? 'You: ${chat.lastMessage!.content}'
                          : chat.isGroup
                              ? '${chat.lastMessage!.senderName}: ${chat.lastMessage!.content}'
                              : chat.lastMessage!.content,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: hasUnread
                            ? (isDark ? Colors.grey[300] : Colors.grey[700])
                            : Colors.grey[500],
                        fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      chat.description ?? 'No messages yet',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String chatId) {
    final colors = [
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];
    return colors[chatId.hashCode % colors.length];
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2332) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.group_add, color: Colors.blue),
                title: Text(
                  'New Group',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'New group feature coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.grey),
                title: Text(
                  'Settings',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Chat settings coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: Colors.grey),
                title: Text(
                  'Archived Chats',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No archived chats',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewChatDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start New Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: Text(
                'New Contact Chat',
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              subtitle: Text(
                'Start a 1-on-1 conversation',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSearchScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: const Icon(Icons.group_add, color: Colors.green),
              ),
              title: Text(
                'New Group Chat',
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              subtitle: Text(
                'Create a group conversation',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Group creation coming soon!',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// Search delegate for chats
class _ChatSearchDelegate extends SearchDelegate<Chat?> {
  final List<Chat> chats;

  _ChatSearchDelegate(this.chats);

  @override
  String get searchFieldLabel => 'Search chats...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A2332) : Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = chats.where((chat) {
      final nameLower = chat.displayName.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Search for chats',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No chats found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: chat.isGroup ? Colors.blue : Colors.purple,
            child: chat.isGroup
                ? const Icon(Icons.groups, color: Colors.white)
                : Text(
                    chat.displayName[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          title: Text(
            chat.displayName,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          subtitle: chat.lastMessage != null
              ? Text(
                  chat.lastMessage!.content,
                  style: GoogleFonts.poppins(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: () {
            close(context, chat);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatConversationScreen(chat: chat),
              ),
            );
          },
        );
      },
    );
  }
}
