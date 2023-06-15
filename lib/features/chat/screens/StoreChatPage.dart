// ignore: file_names
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kmutnb_project/features/chat/screens/chat_screen.dart';
import 'package:kmutnb_project/features/chat/services/chat_service.dart';
import 'package:kmutnb_project/models/store.dart';
import 'package:provider/provider.dart';

import '../../../models/chat.dart';

import '../../../models/userData.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/user_provider.dart';

class StoreChatPage extends StatefulWidget {
  const StoreChatPage({Key? key}) : super(key: key);

  static const String routeName = '/store-chat-page';

  @override
  State<StoreChatPage> createState() => _StoreChatPage();
}

class _StoreChatPage extends State<StoreChatPage> {
  List<Chat> chatHistory = [];
  List<Chat> lastChatHistory = [];
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    getAllChatHistory();
    setState(() {});
  }

  Future<String> getChatName(Chat lastchat) async {
    String chatName;
    Store storeData;
    UserData userdata;

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //print(lastchat.receiverId);

    if (storeProvider == null) {
      userdata = await chatService.getUserByUID(
          context: context, userUID: lastchat.receiverId);
      chatName = userdata.fullName;
    } else if (lastchat.receiverId != storeProvider.store.user &&
        storeProvider.store.user == userProvider.user.id) {
      userdata = await chatService.getUserByUID(
          context: context, userUID: lastchat.receiverId);
      chatName = userdata.fullName;
    } else if (lastchat.receiverId == storeProvider.store.user &&
        storeProvider.store.user == userProvider.user.id) {
      userdata = await chatService.getUserByUID(
          context: context, userUID: lastchat.senderId);
      chatName = userdata.fullName;
    } else if (lastchat.receiverId != userProvider.user.id &&
        storeProvider.store.user != userProvider.user.id) {
      storeData = await chatService.getStoreByUID(
          context: context, storeUID: lastchat.receiverId);
      chatName = storeData.storeName;
    } else if (lastchat.receiverId == userProvider.user.id &&
        storeProvider.store.user != userProvider.user.id) {
      storeData = await chatService.getStoreByUID(
          context: context, storeUID: lastchat.senderId);
      chatName = storeData.storeName;
    } else {
      chatName = 'Name not found';
    }

    return chatName;
  }

  String getTime(DateTime time) {
    final outputFormat = DateFormat("dd/MM HH:mm 'น.'");
    final formattedDate = outputFormat.format(time);
    return formattedDate;
  }

  void changeData() {
    setState(() {
      getAllChatHistory();
      setState(() {});
    });
  }

  Future<void> getAllChatHistory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    chatHistory = await chatService.getAllChatHistory(
      context: context,
      uid: userProvider.user.id,
    );

    setState(() {
      final uniqueReceiverIds = <String>{};
      lastChatHistory = [];

      for (final chat in chatHistory) {
        if (chat.senderId == userProvider.user.id) {
          uniqueReceiverIds.add(chat.receiverId);
        } else if (chat.receiverId == userProvider.user.id) {
          uniqueReceiverIds.add(chat.senderId);
        }
      }

      for (final receiverId in uniqueReceiverIds) {
        final lastSentChat = chatHistory.lastWhere(
          (chat) =>
              chat.senderId == userProvider.user.id &&
              chat.receiverId == receiverId,
          orElse: () => Chat.empty(),
        );

        final lastReceivedChat = chatHistory.lastWhere(
          (chat) =>
              chat.senderId == receiverId &&
              chat.receiverId == userProvider.user.id,
          orElse: () => Chat.empty(),
        );

        final lastChat =
            lastSentChat.timestamp.isAfter(lastReceivedChat.timestamp)
                ? lastSentChat
                : lastReceivedChat;

        lastChatHistory.add(lastChat);
      }

      lastChatHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: ListView.builder(
        itemCount: lastChatHistory.length,
        itemBuilder: (context, index) => GestureDetector(
          child: InkWell(
            onTap: () async {
              String chatName = '';
              Store storeData;

              UserData userdata;
              final storeProvider =
                  Provider.of<StoreProvider>(context, listen: false);

              if (storeProvider == null) {
                userdata = await chatService.getUserByUID(
                    context: context,
                    userUID: lastChatHistory[index].receiverId);
                chatName = userdata.fullName;
              } else if (lastChatHistory[index].receiverId !=
                      storeProvider.store.user &&
                  storeProvider.store.user == userProvider.user.id) {
                userdata = await chatService.getUserByUID(
                    context: context,
                    userUID: lastChatHistory[index].receiverId);
                chatName = userdata.fullName;
              } else if (lastChatHistory[index].receiverId ==
                      storeProvider.store.user &&
                  storeProvider.store.user == userProvider.user.id) {
                userdata = await chatService.getUserByUID(
                    context: context, userUID: lastChatHistory[index].senderId);
                chatName = userdata.fullName;
              } else if (lastChatHistory[index].receiverId !=
                      userProvider.user.id &&
                  storeProvider.store.user != userProvider.user.id) {
                storeData = await chatService.getStoreByUID(
                    context: context,
                    storeUID: lastChatHistory[index].receiverId);
                chatName = storeData.storeName;
              } else if (lastChatHistory[index].receiverId ==
                      userProvider.user.id &&
                  storeProvider.store.user != userProvider.user.id) {
                storeData = await chatService.getStoreByUID(
                    context: context,
                    storeUID: lastChatHistory[index].senderId);
                chatName = storeData.storeName;
              } else {
                chatName = 'Name not found';
              }

              // ignore: use_build_context_synchronously
              final result = await Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: {
                  'receiverId': (lastChatHistory[index].receiverId ==
                          userProvider.user.id)
                      ? lastChatHistory[index].senderId
                      : lastChatHistory[index].receiverId,
                  'chatName': chatName,
                  'senderId': userProvider.user.id,
                },
              );
              if (result == true) {
                changeData();
              }
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueGrey,
                    child: Image.asset(
                      "assets/images/user.png",
                      color: Colors.white,
                      height: 36,
                      width: 36,
                    ),
                  ),
                  title: FutureBuilder<String>(
                    future: getChatName(lastChatHistory[index]),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  subtitle: Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            lastChatHistory[index].message,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          getTime(lastChatHistory[index].timestamp),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 80),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
