import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/live_session_model.dart';

class LiveSessionRoomScreen extends StatefulWidget {
  final LiveSession session;

  const LiveSessionRoomScreen({super.key, required this.session});

  @override
  State<LiveSessionRoomScreen> createState() => _LiveSessionRoomScreenState();
}

class _LiveSessionRoomScreenState extends State<LiveSessionRoomScreen> {
  bool _isMicEnabled = true;
  bool _isCameraEnabled = true;
  bool _isScreenSharing = false;
  bool _showChat = false;
  
  late DateTime _sessionStartTime;
  late Duration _sessionDuration;

  @override
  void initState() {
    super.initState();
    _sessionStartTime = DateTime.now();
    _sessionDuration = Duration(minutes: widget.session.durationMinutes);
  }

  String _getElapsedTime() {
    final elapsed = DateTime.now().difference(_sessionStartTime);
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Feed (Placeholder)
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF1E3A8A),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: Text(
                        widget.session.expertName[0],
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.session.expertName,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.session.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.7),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getElapsedTime(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.session.participantCount} participants',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ControlButton(
                      icon: _isMicEnabled ? Icons.mic : Icons.mic_off,
                      label: 'Mic',
                      isActive: _isMicEnabled,
                      onTap: () => setState(() => _isMicEnabled = !_isMicEnabled),
                    ),
                    _ControlButton(
                      icon: _isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                      label: 'Camera',
                      isActive: _isCameraEnabled,
                      onTap: () => setState(() => _isCameraEnabled = !_isCameraEnabled),
                    ),
                    _ControlButton(
                      icon: Icons.screen_share,
                      label: 'Share',
                      isActive: _isScreenSharing,
                      onTap: () => setState(() => _isScreenSharing = !_isScreenSharing),
                    ),
                    _ControlButton(
                      icon: Icons.chat,
                      label: 'Chat',
                      isActive: _showChat,
                      onTap: () => setState(() => _showChat = !_showChat),
                    ),
                    _ControlButton(
                      icon: Icons.pan_tool,
                      label: 'Raise Hand',
                      isActive: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Hand raised! The expert will call on you.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    _ControlButton(
                      icon: Icons.call_end,
                      label: 'Leave',
                      isActive: false,
                      backgroundColor: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Leave Session', style: GoogleFonts.poppins()),
                            content: Text(
                              'Are you sure you want to leave this session?',
                              style: GoogleFonts.poppins(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: GoogleFonts.poppins()),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Leave',
                                  style: GoogleFonts.poppins(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Chat Sidebar
            if (_showChat)
              Positioned(
                right: 0,
                top: 0,
                bottom: 80,
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    border: Border(
                      left: BorderSide(color: Colors.grey[800]!),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[800]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Chat',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () => setState(() => _showChat = false),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _ChatMessage(
                              username: widget.session.expertName,
                              message: 'Welcome to the session! Feel free to ask questions.',
                              time: timeFormat.format(DateTime.now().subtract(Duration(minutes: 5))),
                              isExpert: true,
                            ),
                            _ChatMessage(
                              username: 'Student',
                              message: 'Thanks for hosting this session!',
                              time: timeFormat.format(DateTime.now().subtract(Duration(minutes: 4))),
                              isExpert: false,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border(
                            top: BorderSide(color: Colors.grey[800]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.poppins(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.blue),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (isActive ? Colors.blue : Colors.grey[800]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final bool isExpert;

  const _ChatMessage({
    required this.username,
    required this.message,
    required this.time,
    required this.isExpert,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                username,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isExpert ? Colors.blue : Colors.white,
                ),
              ),
              if (isExpert) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Expert',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
