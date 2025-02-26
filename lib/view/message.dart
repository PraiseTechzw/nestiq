import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestiq/Components/my_icon_button.dart';
import '../model/message_model.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<String> messagesScreenType = ["All", "Traveling", "Support"];
  int selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(),
                  const Spacer(),
                  MyIconButton(
                    radius: 23,
                    icon: Icons.search,
                    color: Colors.black12.withOpacity(0.03),
                  ),
                  const SizedBox(width: 10),
                  MyIconButton(
                    radius: 23,
                    icon: Icons.tune,
                    color: Colors.black12.withOpacity(0.03),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Messages",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    messagesScreenType.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.black
                                : Colors.black12.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            messagesScreenType[index],
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .where('participants', arrayContains: _auth.currentUser!.uid)
                      .orderBy('lastMessageTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return _buildMessageItem(data, document.id);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> data, String chatId) {
    String otherUserId = (data['participants'] as List<dynamic>)
        .firstWhere((id) => id != _auth.currentUser!.uid);

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(otherUserId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return const Text('Error loading user data');
        }

        Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(chatId: chatId, otherUserId: otherUserId),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 85,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(userData['profileImage'] ?? ''),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 25),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userData['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            _formatDate(data['lastMessageTime'] as Timestamp),
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        data['lastMessage'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.1,
                          fontSize: 17,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
