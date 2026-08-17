import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl;
    Uint8List? imageBytes;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageUrl);
      } catch (e) {
        imageBytes = null; // falls String kein gültiges Base64 ist
      }
    }

    return CircleAvatar(
      backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
      child: imageBytes == null ? Icon(Icons.person, size: 30) : null,
    );
  }
}
