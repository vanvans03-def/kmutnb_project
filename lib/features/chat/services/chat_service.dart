import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/chat.dart';
import '../../../models/store.dart';

import '../../../models/userData.dart';

class ChatService {
  Future<List<Chat>> getChatHistory({
    required BuildContext context,
    required String senderId,
    required String receiverId,
  }) async {
    List<Chat> chatList = [];
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/chat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // แก้ไขตรงนี้
        },
        body: jsonEncode(
          {
            'senderId': senderId,
            'receiverId': receiverId,
          },
        ),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);
            var data = responseJson['data'];
            for (int i = 0; i < data.length; i++) {
              chatList.add(
                Chat.fromJson(data[i] as Map<String, dynamic>),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return chatList;
  }

  Future<List<Chat>> getAllChatHistory({
    required BuildContext context,
    required String uid,
  }) async {
    List<Chat> chatList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/chat-byUID?uid=$uid'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // แก้ไขตรงนี้
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);
            var data = responseJson['data'];
            for (int i = 0; i < data.length; i++) {
              chatList.add(
                Chat.fromJson(data[i] as Map<String, dynamic>),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return chatList;
  }

  Future<Store> getStoreByUID({
    required BuildContext context,
    required String storeUID,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/my-store/$storeUID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var data;
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          data = responseJson['data'];
        },
      );

      if (data != null && data.isNotEmpty) {
        return Store.fromMap(data[0]);
      } else {
        throw Exception('No data received');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      rethrow;
    }
  }

  Future<UserData> getUserByUID({
    required BuildContext context,
    required String userUID,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/getUserData/$userUID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data;
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          data = responseJson['data'];
        },
      );
      return UserData.fromJson(data);
    } catch (e) {
      showSnackBar(context, e.toString());
      rethrow;
    }
  }
}
