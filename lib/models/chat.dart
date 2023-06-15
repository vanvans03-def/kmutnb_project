import 'dart:convert';

class Chat {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> map) => Chat.fromMap(map);

  String toJson() => json.encode(toMap());

  static Chat empty() {
    return Chat(
      senderId: '',
      receiverId: '',
      message: '',
      timestamp: DateTime(2000),
    );
  }

  DateTime get localTimestamp {
    // แปลงเวลาไปยังเขตเวลาท้องถิ่น (Asia/Bangkok) โดยใช้ Timezone Offset
    final localOffset = DateTime.now().timeZoneOffset;
    final localDateTime = timestamp.add(localOffset);
    return localDateTime;
  }
}
