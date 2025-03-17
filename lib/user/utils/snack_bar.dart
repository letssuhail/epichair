import 'package:flutter/material.dart';

void showTopSnackBar(String message, dynamic navigatorKey) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  final entry = OverlayEntry(
    builder: (_) => Positioned(
      top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .padding
              .top +
          10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 2), entry.remove);
}
