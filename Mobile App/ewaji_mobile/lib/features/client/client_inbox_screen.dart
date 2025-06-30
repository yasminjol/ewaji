import 'package:flutter/material.dart';

class ClientInboxScreen extends StatelessWidget {
  const ClientInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {
        'id': 1,
        'providerName': "Sophia's Hair Studio",
        'lastMessage': 'Thanks for booking! See you tomorrow at 2 PM.',
        'timestamp': '2 min ago',
        'unread': true,
        'avatar': 'S',
      },
      {
        'id': 2,
        'providerName': 'Glamour Nails',
        'lastMessage': 'Your appointment is confirmed for Friday.',
        'timestamp': '1 hour ago',
        'unread': false,
        'avatar': 'G',
      },
      {
        'id': 3,
        'providerName': 'Bella Beauty',
        'lastMessage': 'How did you like your facial treatment?',
        'timestamp': '2 days ago',
        'unread': false,
        'avatar': 'B',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF5E50A1)),
            onPressed: () {},
          ),
        ],
      ),
      body: conversations.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationTile(conversation);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with your providers',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFF5E50A1),
        child: Text(
          conversation['avatar'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        conversation['providerName'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: conversation['unread'] ? FontWeight.w600 : FontWeight.w500,
          color: const Color(0xFF1C1C1E),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          conversation['lastMessage'],
          style: TextStyle(
            fontSize: 14,
            color: conversation['unread'] ? const Color(0xFF1C1C1E) : Colors.grey[600],
            fontWeight: conversation['unread'] ? FontWeight.w500 : FontWeight.normal,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation['timestamp'],
            style: TextStyle(
              fontSize: 12,
              color: conversation['unread'] ? const Color(0xFF5E50A1) : Colors.grey[600],
              fontWeight: conversation['unread'] ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (conversation['unread']) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF5E50A1),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // Navigate to chat screen
        _showChatScreen(conversation);
      },
    );
  }

  void _showChatScreen(Map<String, dynamic> conversation) {
    // This would navigate to a chat screen in a real app
    // For now, we'll show a simple dialog
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(conversation: conversation)));
  }
}
