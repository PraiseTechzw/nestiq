// Add these imports at the top
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatScreen({Key? key, required this.chatId, required this.otherUserId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  Timer? _typingTimer;
  StreamSubscription? _typingSubscription;

  @override
  void initState() {
    super.initState();
    _setupTypingListener();
    _updateUserStatus(true);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _typingSubscription?.cancel();
    _updateUserStatus(false);
    super.dispose();
  }

  void _setupTypingListener() {
    _typingSubscription = _firestore
        .collection('chats')
        .doc(widget.chatId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final typingUsers = data['typingUsers'] as Map<String, dynamic>? ?? {};
        // Update UI if other user is typing
        if (mounted && typingUsers[widget.otherUserId] == true) {
          // Show typing indicator
          setState(() {});
        }
      }
    });
  }

  void _updateTypingStatus(bool isTyping) {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () async {
      await _firestore.collection('chats').doc(widget.chatId).update({
        'typingUsers.${_auth.currentUser!.uid}': isTyping,
      });
    });
  }

  Future<void> _updateUserStatus(bool isOnline) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(widget.otherUserId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData['name'] ?? 'Chat'),
                  Text(
                    userData['isOnline'] == true ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: userData['isOnline'] == true ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              );
            }
            return const Text('Chat');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return _buildMessageBubble(data);
                  }).toList(),
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('chats').doc(widget.chatId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final typingUsers = data['typingUsers'] as Map<String, dynamic>? ?? {};
                if (typingUsers[widget.otherUserId] == true) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Typing...', style: TextStyle(fontStyle: FontStyle.italic)),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> data) {
    bool isMe = data['senderId'] == _auth.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data['text'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                _formatTimestamp(data['timestamp'] as Timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (isMe) Icon(
                data['isRead'] == true ? Icons.done_all : Icons.done,
                size: 16,
                color: data['isRead'] == true ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {
                _updateTypingStatus(text.isNotEmpty);
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text;
    _messageController.clear();
    _updateTypingStatus(false);

    final messageDoc = await _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': messageText,
      'senderId': _auth.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    await _firestore.collection('chats').doc(widget.chatId).update({
      'lastMessage': messageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageId': messageDoc.id,
      'unreadCount.${widget.otherUserId}': FieldValue.increment(1),
    });
  }
}