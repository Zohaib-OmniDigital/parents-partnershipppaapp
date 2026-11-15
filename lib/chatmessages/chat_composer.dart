import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/flutter_flow/flutter_flow_theme.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.isSending,
    this.replyToSender,
    this.replyToText,
    required this.onCancelReply,
    required this.onSend,
    required this.onSendImage,
    required this.onTypingChanged,
  });

  final TextEditingController textController;
  final FocusNode focusNode;
  final bool isSending;
  final String? replyToSender;
  final String? replyToText;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;
  final void Function(Uint8List imageBytes, String filename, String caption) onSendImage;
  final void Function(bool isTyping) onTypingChanged;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final ImagePicker _picker = ImagePicker();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.textController.text.trim().isNotEmpty;
    widget.textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasNow = widget.textController.text.trim().isNotEmpty;
    if (hasNow != _hasText) {
      setState(() => _hasText = hasNow);
    }
    widget.onTypingChanged(hasNow);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  Future<void> _pickAttachment(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      _showImagePreviewDialog(bytes, picked.name);
    } catch (e) {
      debugPrint('Failed to pick image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load image. Please try again.')),
        );
      }
    }
  }

  void _showImagePreviewDialog(Uint8List bytes, String filename) {
    final theme = FlutterFlowTheme.of(context);
    final captionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Send Photo',
                    style: theme.titleSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  width: double.infinity,
                  color: Colors.black12,
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Add a caption…',
                  hintStyle: theme.bodySmall.copyWith(color: theme.secondaryText),
                  filled: true,
                  fillColor: theme.primaryBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      final caption = captionController.text.trim();
                      Navigator.of(context).pop();
                      widget.onSendImage(bytes, filename, caption);
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Send'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentOptions() {
    final theme = FlutterFlowTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.secondaryText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentItem(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: const Color(0xFFE91E63),
                      onTap: () => _pickAttachment(ImageSource.camera),
                    ),
                    _buildAttachmentItem(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: const Color(0xFF9C27B0),
                      onTap: () => _pickAttachment(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasReply = widget.replyToSender != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(
          top: BorderSide(color: theme.alternate.withValues(alpha: 0.8), width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview Banner
            if (hasReply)
              Container(
                padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.06),
                  border: Border(
                    left: BorderSide(color: theme.primary, width: 3.5),
                    bottom: BorderSide(color: theme.alternate, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Replying to ${widget.replyToSender}',
                            style: TextStyle(
                              color: theme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.replyToText ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.bodySmall.copyWith(
                              color: theme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: theme.secondaryText,
                      onPressed: widget.onCancelReply,
                    ),
                  ],
                ),
              ),

            // Input Row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attachment button
                  IconButton(
                    tooltip: 'Attach photo',
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: theme.primary,
                      size: 26,
                    ),
                    onPressed: widget.isSending ? null : _showAttachmentOptions,
                  ),

                  // Expanding text field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: theme.alternate, width: 0.8),
                      ),
                      child: TextField(
                        controller: widget.textController,
                        focusNode: widget.focusNode,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.newline,
                        maxLength: 4000,
                        style: theme.bodyMedium.copyWith(fontSize: 14.5),
                        decoration: InputDecoration(
                          hintText: 'Message…',
                          hintStyle: theme.bodySmall.copyWith(
                            color: theme.secondaryText.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                          isDense: true,
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send button with micro-animation
                  AnimatedScale(
                    scale: _hasText || widget.isSending ? 1.0 : 0.88,
                    duration: const Duration(milliseconds: 150),
                    child: IconButton.filled(
                      tooltip: 'Send',
                      onPressed: (_hasText && !widget.isSending) ? widget.onSend : null,
                      style: IconButton.styleFrom(
                        backgroundColor: _hasText ? theme.primary : theme.alternate,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: theme.alternate.withValues(alpha: 0.5),
                        disabledForegroundColor: theme.secondaryText.withValues(alpha: 0.4),
                        padding: const EdgeInsets.all(10),
                      ),
                      icon: widget.isSending
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.arrow_upward_rounded, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
