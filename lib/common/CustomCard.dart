import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kmutnb_project/features/chat/screens/chat_screen.dart';
import 'package:kmutnb_project/features/chat/services/chat_service.dart';

import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../providers/user_provider.dart';

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  CustomCard({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);
  final Chat chatModel;
  final Chat sourchat;
  ChatService chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return InkWell(
      onTap: () async {
        print(chatModel.receiverId);

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: {
            'receiverId': sourchat.receiverId,
            'chatName': 'chatName',
            'senderId': userProvider.user.id,
          },
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            title: Text(
              chatModel.receiverId,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.message,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.timestamp.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
