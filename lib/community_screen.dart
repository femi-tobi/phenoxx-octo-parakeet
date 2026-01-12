import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_conversation_screen.dart';
import 'services/chat_service.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

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
          'Community',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 18,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: GoogleFonts.poppins(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search topics, users, code',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'All', isSelected: true, isDark: isDark),
                    const SizedBox(width: 8),
                    _FilterChip(label: '#Python', isSelected: false, isDark: isDark),
                    const SizedBox(width: 8),
                    _FilterChip(label: '#DevOps', isSelected: false, isDark: isDark),
                    const SizedBox(width: 8),
                    _FilterChip(label: '#Flutter', isSelected: false, isDark: isDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mentorship Programs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mentorship Programs',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Mentorship Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage('assets/mentorship_bg.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF1E3A8A).withOpacity(0.8),
                      Color(0xFF3B82F6).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'FEATURED',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join a Mentorship Circle',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Connect with senior devs & accelerate your career',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              // Get or create the mentorship group chat
                              final chatService = ChatService();
                              final chat = chatService.getChatById('chat_mentorship');
                              if (chat != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatConversationScreen(chat: chat),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Join Now',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A2332) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        labelColor: textColor,
                        unselectedLabelColor: Colors.grey[500],
                        indicator: BoxDecoration(
                          color: isDark ? const Color(0xFF2A3A52) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Latest Discussion'),
                          Tab(text: 'Popular Topics'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Discussion Posts
                  _DiscussionPost(
                    username: '@dev.jane',
                    avatarColor: Colors.purple,
                    title: 'Best Practices in Python',
                    content: 'From experience: follow PEP 8, name things clearly, keep it simple, break code to functions, use virtual envs, handle errors, don\'t repeat yourself, use Git, test early and write better code.',
                    likes: 42,
                    comments: 8,
                    isDark: isDark,
                  ),
                  _DiscussionPost(
                    username: '@alex_codes',
                    avatarColor: Colors.orange,
                    title: 'Things I Learned the Hard Way About Coding',
                    content: 'Keep it simple, name things clearly, break your code to small parts, test early and document enough so future you doesn\'t suffer...',
                    likes: 18,
                    comments: 10,
                    isDark: isDark,
                  ),
                  _DiscussionPost(
                    username: '@sarah_deployhard',
                    avatarColor: Colors.green,
                    title: 'Need Coding Help',
                    content: 'Stuck, tired, and my code hates me — any tips welcome.',
                    tag: 'Just Started',
                    tagColor: Colors.green,
                    likes: 24,
                    comments: 5,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue
            : (isDark ? const Color(0xFF1A2332) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? null
            : Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey[400] : Colors.grey[700]),
        ),
      ),
    );
  }
}

class _DiscussionPost extends StatelessWidget {
  final String username;
  final Color avatarColor;
  final String title;
  final String content;
  final String? tag;
  final Color? tagColor;
  final int likes;
  final int comments;
  final bool isDark;

  const _DiscussionPost({
    required this.username,
    required this.avatarColor,
    required this.title,
    required this.content,
    this.tag,
    this.tagColor,
    required this.likes,
    required this.comments,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 18,
                child: Text(
                  username[1].toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                username,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (tag != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: tagColor ?? Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 18, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                likes.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 20),
              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                comments.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(),
              Icon(Icons.share_outlined, size: 18, color: Colors.grey[500]),
            ],
          ),
        ],
      ),
    );
  }
}
