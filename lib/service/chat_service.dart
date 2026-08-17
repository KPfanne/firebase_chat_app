import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:intl/intl.dart';

class ChatService {
  final UserService _userService;

  ChatService({required this._userService});

  Stream<QuerySnapshot> getChatHistory(String chatPartnerId) {
    String chatId = getChatId(_userService.currentUserId, chatPartnerId);
    return _userService.fireStore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time_stamp', descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  String getChatId(String currentId, String chatPartnerId) {
    List<String> ids = [currentId, chatPartnerId]..sort();
    return ids.join("_");
  }

  String getDateTimeOfMessage(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('HH:mm - dd.MM.yyyy').format(dateTime);
  }

  Future<void> sendMessage(String message, String chatPartnerId) async {
    String chatId = getChatId(_userService.currentUserId, chatPartnerId);
    await _userService.fireStore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          "senderId": _userService.currentUserId,
          "message": message,
          "time_stamp": FieldValue.serverTimestamp(),
        });
  }
}
