import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/model/appuser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final ImagePicker imagePicker = ImagePicker();

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  String? profileImagePath;
  String? chatPartnerProfileImagePath;

  Future<void> loadUserProfileImage() async {
    if (currentUserId.isEmpty) return;

    try {
      final snapshot = await fireStore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
        profileImagePath = dataMap['imageUrl'] as String?;
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> loadChatPartnerProfileImage(String chatPartnerId) async {
    try {
      final snapshot = await fireStore
          .collection('users')
          .doc(chatPartnerId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
        chatPartnerProfileImagePath = dataMap['imageUrl'] as String?;
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    String uid = userData["uid"] as String;
    await fireStore.collection('users').doc(uid).set(userData);
  }

  Future<void> addContactByMail(String email) async {
    QuerySnapshot snapshot = await fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      log("Email existiert nicht");
      return;
    }

    final contactId = snapshot.docs.first.id;

    if (contactId == currentUserId) return;

    await fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('contacts')
        .doc(contactId)
        .set({'uid': contactId});
  }

  Future<List<AppUser>> getAllContacts() async {
    final contactsSnapshot = await fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('contacts')
        .get();

    List<AppUser> freshContacts = [];

    for (var doc in contactsSnapshot.docs) {
      final contactId = doc.id;
      final userDoc = await fireStore.collection('users').doc(contactId).get();
      if (userDoc.exists && userDoc.data() != null) {
        freshContacts.add(
          AppUser.fromMap(userDoc.data() as Map<String, dynamic>),
        );
      }
    }

    return freshContacts;
  }

  Future<void> uploadProfilePicture() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
      );

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      await fireStore.collection('users').doc(currentUserId).set({
        "imageUrl": base64Image,
      }, SetOptions(merge: true));

      profileImagePath = base64Image;

      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
