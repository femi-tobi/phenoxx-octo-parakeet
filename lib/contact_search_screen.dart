import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_model.dart';
import 'models/chat_model.dart';
import 'services/chat_service.dart';
import 'chat_conversation_screen.dart';

class ContactSearchScreen extends StatefulWidget {
  const ContactSearchScreen({super.key});

  @override
  State<ContactSearchScreen> createState() => _ContactSearchScreenState();
}

class _ContactSearchScreenState extends State<ContactSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    // Mock users - in production, this would come from your backend API
    _allUsers = [
      User(id: 'user_10', name: 'Tom Brown', email: 'tom.brown@example.com'),
      User(id: 'user_11', name: 'Lisa White', email: 'lisa.white@example.com'),
      User(id: 'user_12', name: 'Kevin Zhang', email: 'kevin.zhang@example.com'),
      User(id: 'user_13', name: 'Maria Garcia', email: 'maria.garcia@example.com'),
      User(id: 'user_14', name: 'James Wilson', email: 'james.wilson@example.com'),
      User(id: 'user_15', name: 'Sophie Chen', email: 'sophie.chen@example.com'),
      User(id: 'user_16', name: 'Daniel Martinez', email: 'daniel.martinez@example.com'),
      User(id: 'user_17', name: 'Emily Taylor', email: 'emily.taylor@example.com'),
      User(id: 'user_18', name: 'Ryan Anderson', email: 'ryan.anderson@example.com'),
      User(id: 'user_19', name: 'Olivia Thompson', email: 'olivia.thompson@example.com'),
    ];
    _filteredUsers = _allUsers;
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers.where((user) {
          final nameLower = user.name.toLowerCase();
          final emailLower = user.email.toLowerCase();
          return nameLower.contains(query) || emailLower.contains(query);
        }).toList();
      }
    });
  }

  void _startChat(User user) {
    // Check if chat already exists
    final existingChatId = 'chat_${user.id}';
    var chat = _chatService.getChatById(existingChatId);

    if (chat == null) {
      // Create new chat
      chat = Chat(
        id: existingChatId,
        name: user.name,
        type: ChatType.individual,
        participantIds: [_chatService.currentUserId, user.id],
        participantNames: [user.name],
        unreadCount: 0,
      );
      
      // Add chat to service (for mock purposes)
      // In production, this would be an API call
    }

    // Navigate to chat
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(chat: chat!),
      ),
    );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Chat',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              autofocus: true,
            ),
          ),

          // Results or empty state
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty
                              ? Icons.person_search
                              : Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Search for contacts'
                              : 'No users found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_searchController.text.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Type a name or email to find people',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return _buildUserItem(user, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(User user, bool isDark) {
    final colors = [
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    final color = colors[user.id.hashCode % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 24,
          child: Text(
            user.initials,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          user.email,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Chat',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () => _startChat(user),
      ),
    );
  }
}
