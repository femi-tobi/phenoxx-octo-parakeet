import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/chat_model.dart';

class GroupInfoScreen extends StatelessWidget {
  final Chat chat;

  const GroupInfoScreen({super.key, required this.chat});

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
          'Group Info',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Group header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.groups, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    chat.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (chat.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      chat.description!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Group • ${chat.participantIds.length} members',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.notifications_outlined,
                    iconColor: Colors.blue,
                    title: 'Mute Notifications',
                    isDark: isDark,
                    onTap: () {},
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildActionItem(
                    icon: Icons.wallpaper_outlined,
                    iconColor: Colors.green,
                    title: 'Wallpaper',
                    isDark: isDark,
                    onTap: () {},
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  _buildActionItem(
                    icon: Icons.search,
                    iconColor: Colors.orange,
                    title: 'Search',
                    isDark: isDark,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Members section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${chat.participantIds.length} Members',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.person_add, color: Colors.blue),
                          onPressed: () {
                            // TODO: Add member
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                  ...chat.participantNames.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    return Column(
                      children: [
                        _buildMemberItem(
                          name: name,
                          isAdmin: index == 1, // Second person is admin (Sarah Chen in mock data)
                          isDark: isDark,
                        ),
                        if (index < chat.participantNames.length - 1)
                          Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Exit group button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                onTap: () {
                  _showExitGroupDialog(context);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tileColor: isDark ? const Color(0xFF1A2332) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.exit_to_app, color: Colors.red, size: 24),
                ),
                title: Text(
                  'Exit Group',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[500]),
    );
  }

  Widget _buildMemberItem({
    required String name,
    required bool isAdmin,
    required bool isDark,
  }) {
    final colors = [
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.pink,
      Colors.blue,
    ];
    final color = colors[name.hashCode % colors.length];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 22,
        child: Text(
          name[0].toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Admin',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        'Hey there! I am using this chat app',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.grey[500]),
        onPressed: () {
          // TODO: Member options
        },
      ),
    );
  }

  void _showExitGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Exit Group?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to exit this group? You will no longer receive messages from this group.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Exit',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
