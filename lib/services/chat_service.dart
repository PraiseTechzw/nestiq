import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get or create chat room
  Future<String> getOrCreateChatRoom(String otherUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    final users = [currentUserId, otherUserId]..sort();
    final chatRoomId = users.join('_');

    final chatRoom = await _firestore.collection('chatRooms').doc(chatRoomId).get();
    if (!chatRoom.exists) {
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'users': users,
        'lastMessage': null,
        'lastMessageTime': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  // Send message
  Future<void> sendMessage(String chatRoomId, String message) async {
    final currentUserId = _auth.currentUser!.uid;
    await _firestore.collection('chatRooms/$chatRoomId/messages').add({
      'senderId': currentUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms/$chatRoomId/messages')
        .orderBy('timestamp')
        .snapshots();
  }

  // Get chat rooms for current user
  Stream<QuerySnapshot> getChatRooms() {
    final currentUserId = _auth.currentUser!.uid;
    return _firestore
        .collection('chatRooms')
        .where('users', arrayContains: currentUserId)
        .snapshots();
  }

  // Get chat room info
  Stream<DocumentSnapshot> getChatRoomInfo(String chatRoomId) {
    return _firestore.collection('chatRooms').doc(chatRoomId).snapshots();
  }

  // Create or get chat room
  Future<String> createOrGetChatRoom(String otherUserId) async {
    final currentUserId = _auth.currentUser?.uid;
    final users = [currentUserId, otherUserId]..sort();
    final chatRoomId = users.join('_');

    final chatRoom = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();

    if (!chatRoom.exists) {
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();
      final otherUserDoc = await _firestore
          .collection('users')
          .doc(otherUserId)
          .get();

      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'users': users,
        'userInfo': {
          currentUserId: {
            'name': currentUserDoc.data()?['fullName'],
            'photo': currentUserDoc.data()?['photoUrl'],
          },
          otherUserId: {
            'name': otherUserDoc.data()?['fullName'],
            'photo': otherUserDoc.data()?['photoUrl'],
          },
        },
        'lastMessage': null,
        'lastMessageTime': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomId) async {
    final currentUserId = _auth.currentUser?.uid;
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
  }
}

