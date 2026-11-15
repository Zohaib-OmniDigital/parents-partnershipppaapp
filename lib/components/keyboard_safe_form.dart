import 'package:flutter/material.dart';

/// Keeps form content clear of the on-screen keyboard and scrolls a focused
/// field into a comfortable viewing position.
///
/// Wrap each input with [KeyboardSafeFormField] and place the form in a
/// [KeyboardSafeScrollView]. This works for every scrollable form in the app.
class KeyboardSafeScrollView extends StatelessWidget {
  const KeyboardSafeScrollView({
    super.key,
    required this.child,
    this.controller,
    this.padding = EdgeInsets.zero,
    this.physics,
  });

  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding.resolve(Directionality.of(context));
    return SingleChildScrollView(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: resolvedPadding.add(
        EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      ),
      child: child,
    );
  }
}

/// Wraps an input that has a [FocusNode] so it is revealed after the keyboard
/// opens. The delay lets the platform finish its keyboard animation first.
class KeyboardSafeFormField extends StatefulWidget {
  const KeyboardSafeFormField({
    super.key,
    required this.focusNode,
    required this.child,
    this.alignment = 0.18,
  });

  final FocusNode focusNode;
  final Widget child;
  final double alignment;

  @override
  State<KeyboardSafeFormField> createState() => _KeyboardSafeFormFieldState();
}

class _KeyboardSafeFormFieldState extends State<KeyboardSafeFormField> {
  final _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_revealFieldWhenFocused);
  }

  @override
  void didUpdateWidget(covariant KeyboardSafeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_revealFieldWhenFocused);
      widget.focusNode.addListener(_revealFieldWhenFocused);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_revealFieldWhenFocused);
    super.dispose();
  }

  void _revealFieldWhenFocused() {
    if (!widget.focusNode.hasFocus) return;

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!mounted || !widget.focusNode.hasFocus) return;
      final fieldContext = _fieldKey.currentContext;
      if (fieldContext != null) {
        Scrollable.ensureVisible(
          fieldContext,
          alignment: widget.alignment,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _fieldKey, child: widget.child);
  }
}
