import 'package:flutter/material.dart';
import 'package:nestiq/services/chat_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder(
        stream: ChatService().getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages yet'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chatRoom = snapshot.data!.docs[index];
              final lastMessage = chatRoom['lastMessage'];
              final lastMessageTime = chatRoom['lastMessageTime']?.toDate();

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chatRoom['otherUserPhoto']),
                ),
                title: Text(chatRoom['otherUserName']),
                subtitle: Text(
                  lastMessage ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: lastMessageTime != null
                    ? Text(
                        timeago.format(lastMessageTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : null,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: chatRoom.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

