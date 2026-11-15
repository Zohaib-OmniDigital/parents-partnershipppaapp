import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.primary, size: 30),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.bodyMedium.copyWith(
                  color: theme.secondaryText,
                  height: 1.45,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message = 'Something went wrong. Please try again.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppEmptyState(
        icon: Icons.cloud_off_rounded,
        title: 'Unable to load',
        message: message,
        actionLabel: onRetry == null ? null : 'Try again',
        onAction: onRetry,
      );
}

class AppShimmerList extends StatefulWidget {
  const AppShimmerList({super.key, this.itemCount = 5, this.padding});

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppShimmerList> createState() => _AppShimmerListState();
}

class _AppShimmerListState extends State<AppShimmerList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(-1.8 + _controller.value * 3.6, 0),
          end: Alignment(-0.8 + _controller.value * 3.6, 0),
          colors: [
            const Color(0xFFE8EBF0),
            theme.primary.withValues(alpha: 0.16),
            const Color(0xFFE8EBF0),
          ],
          stops: const [0.25, 0.5, 0.75],
        ).createShader(bounds),
        child: child,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: widget.padding ?? const EdgeInsets.all(16),
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class AppNetworkAvatar extends StatelessWidget {
  const AppNetworkAvatar({
    super.key,
    this.url,
    this.size = 48,
    this.semanticLabel = 'Profile photo',
  });

  final String? url;
  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final validUrl = url != null && Uri.tryParse(url!)?.hasAbsolutePath == true;
    final fallback = ColoredBox(
      color: theme.primary.withValues(alpha: 0.10),
      child:
          Icon(Icons.person_rounded, color: theme.primary, size: size * 0.52),
    );

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ClipOval(
        child: SizedBox.square(
          dimension: size,
          child: validUrl
              ? CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => fallback,
                  errorWidget: (_, __, ___) => fallback,
                  fadeInDuration: const Duration(milliseconds: 180),
                )
              : fallback,
        ),
      ),
    );
  }
}

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({super.key, required this.label, required this.type});

  final String label;
  final AppStatusType type;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final color = switch (type) {
      AppStatusType.success => theme.success,
      AppStatusType.warning => const Color(0xFFB76E00),
      AppStatusType.error => theme.error,
      AppStatusType.info => theme.primary,
      AppStatusType.neutral => theme.secondaryText,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum AppStatusType { success, warning, error, info, neutral }
