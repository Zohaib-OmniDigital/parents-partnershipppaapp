// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CustomLoadingScreen extends StatefulWidget {
  const CustomLoadingScreen({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  final double? width;
  final double? height;
  final Color? color;

  @override
  State<CustomLoadingScreen> createState() => _CustomLoadingScreenState();
}

class _CustomLoadingScreenState extends State<CustomLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    final baseColor = theme.alternate.withValues(alpha: 0.55);
    final highlightColor = (widget.color ?? theme.primary).withValues(alpha: 0.20);

    return ColoredBox(
      color: theme.primaryBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment(-1.5 + (_controller.value * 3), -0.3),
                  end: Alignment(-0.5 + (_controller.value * 3), 0.3),
                  colors: [baseColor, highlightColor, baseColor],
                  stops: const [0.2, 0.5, 0.8],
                ).createShader(bounds),
                child: child,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _block(width: 52, height: 52, radius: 16),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _block(width: 180, height: 18),
                          const SizedBox(height: 9),
                          _block(width: 120, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                _block(height: 160, radius: 24),
                const SizedBox(height: 26),
                _block(width: 190, height: 22),
                const SizedBox(height: 18),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _block(height: 76, radius: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _block({double? width, required double height, double radius = 10}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!
