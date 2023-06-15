import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/chat/services/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../constants/global_variables.dart';
import '../../../models/chat.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String chatName;
  final String senderId;
  final String image;
  static const String routeName = '/chat';

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.senderId,
    required this.chatName,
    required this.image,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;

  bool showDate = false; // Variable to track the display of the date

  TextEditingController messageController = TextEditingController();
  List<String> chatMessages = [];
  List<Chat> chatHistory = [];
  int showDateIndex = 0;
  final ChatService chatService = ChatService();
  @override
  void initState() {
    super.initState();
    connectSocket();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    chatHistory = await chatService.getChatHistory(
      context: context,
      senderId: widget.senderId,
      receiverId: widget.receiverId,
    );

    setState(() {
      // อัปเดตสถานะของ UI หลังจากเรียงลำดับ
    });
  }

  void connectSocket() {
    socket = IO.io('http://192.168.1.159:3700', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('chat message', (data) {
      setState(() {
        chatMessages.add(data['message']);
      });
    });
    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('message', {
      'senderId': widget.senderId,
      'receiverId': widget.receiverId,
      'message': message,
    });

    setState(() {
      loadChatHistory();
      showDateIndex = 0;
      showDate = false;
    });
    messageController.clear();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: Row(
          children: [
            if (widget.image == '') ...[
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 22,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else ...[
              CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 25,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.image,
                  ),
                  radius: 22,
                ),
              ),
            ],
            const SizedBox(
              width: 15,
            ),
            Text(
              ' ${widget.chatName}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // เพื่อให้เรียงลำดับจากล่าสุดไปยังเก่าสุด
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                final isSentMessage = chat.senderId == widget.senderId;
                final timeDate = chat.localTimestamp.toString();

                final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
                final outputFormat = DateFormat("HH:mm 'น.'");

                final parsedDate = inputFormat.parse(timeDate);
                final formattedDate = outputFormat.format(parsedDate);

                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (isSentMessage
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showDate = !showDate;
                          showDateIndex = index;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDate && index == showDateIndex)
                            Container(
                              //margin: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (isSentMessage
                                  ? GlobalVariables.kPrimaryColorsecond
                                  : Colors.grey.shade200),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              chat.message,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(messageController.text);
                    messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
