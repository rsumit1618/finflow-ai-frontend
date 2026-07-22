import 'package:flutter/material.dart';

enum ErrorType {
  network,
  server,
  validation,
  unknown,
}

class ErrorHandlerUI {
  static void showError(BuildContext context, String message,
      {ErrorType type = ErrorType.unknown}) {
    String title;
    IconData icon;
    Color color;

    switch (type) {
      case ErrorType.network:
        title = 'Network Error';
        icon = Icons.wifi_off;
        color = Colors.orange.shade800;
        break;
      case ErrorType.server:
        title = 'Server Error';
        icon = Icons.dns;
        color = Colors.red.shade800;
        break;
      case ErrorType.validation:
        title = 'Input Error';
        icon = Icons.error_outline;
        color = Colors.blue.shade800;
        break;
      default:
        title = 'Oops!';
        icon = Icons.warning_amber;
        color = Colors.blueGrey.shade800;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => overlayEntry.remove(),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
