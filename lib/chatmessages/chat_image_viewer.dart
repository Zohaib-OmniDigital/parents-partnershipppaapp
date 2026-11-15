import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ChatImageViewer extends StatelessWidget {
  const ChatImageViewer({
    super.key,
    required this.imageUrl,
    this.caption,
    this.senderName,
  });

  final String imageUrl;
  final String? caption;
  final String? senderName;

  static void open(
    BuildContext context, {
    required String imageUrl,
    String? caption,
    String? senderName,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatImageViewer(
          imageUrl: imageUrl,
          caption: caption,
          senderName: senderName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: senderName != null
            ? Text(
                senderName!,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              )
            : null,
      ),
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image_rounded, color: Colors.white54, size: 64),
              ),
            ),
          ),
          if (caption != null && caption!.trim().isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.75),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                child: Text(
                  caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

