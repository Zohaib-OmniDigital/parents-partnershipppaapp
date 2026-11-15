import 'package:flutter/material.dart';
import '/achats/chat_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ChatDateSeparator extends StatelessWidget {
  const ChatDateSeparator({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final dateStr = ChatService.formatDateDivider(date);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: theme.alternate.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          dateStr,
          style: theme.labelSmall.copyWith(
            color: theme.secondaryText,
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}

