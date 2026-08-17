import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomMessageBar extends StatefulWidget {
  final GlobalKey<void> _globalKey;
  final TextEditingController messageController;
  final VoidCallback onPressed;

  const BottomMessageBar({
    super.key,
    required this._globalKey,
    required this.messageController,
    required this.onPressed,
  });

  @override
  State<BottomMessageBar> createState() => _BottomMessageBarState();
}

class _BottomMessageBarState extends State<BottomMessageBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: widget._globalKey,
              child: TextFormField(
                controller: widget.messageController,
                style: TextStyle(color: AppColors.textPrimary),
                cursorColor: AppColors.accent,
                decoration: InputDecoration(
                  hintText: "Write Something",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  fillColor: AppColors.glassSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: widget.onPressed,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
