// ChatHistoryScreen
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const String routeName = '/chat_history';

  const ChatHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: ดึงประวัติการแชทจากแหล่งข้อมูล เช่น API หรือฐานข้อมูล

    // สมมติให้ประวัติการแชทเป็น List ของผู้ใช้ (User) ที่เกี่ยวข้อง
    List<User> chatUsers = [
      User(id: '63ec42477f5571e23fadc34b', name: 'Benjaporn '),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          User user = chatUsers[index];
          return Column(
            children: [
              ListTile(
                title: Text(user.name),
                onTap: () {
                  // เมื่อผู้ใช้แตะ เรียกเมธอดเพื่อเปิดหน้าแชท 1-1
                  _openChatScreen(context, user);
                },
              ),
              const Divider(
                thickness: 1,
              ), // เพิ่มเส้นขีดระหว่างผู้ใช้
            ],
          );
        },
      ),
    );
  }

  void _openChatScreen(BuildContext context, User user) {
    // TODO: นำข้อมูลผู้ใช้ไปใช้ในหน้าแชท 1-1 โดยใช้ user.id หรือข้อมูลที่เกี่ยวข้อง
    Navigator.pushNamed(context, '/chat', arguments: {
      'userIdB': user.id,
      'userNameB': user.name,
    });
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}
