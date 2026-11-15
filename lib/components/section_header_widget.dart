import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'section_header_model.dart';
export 'section_header_model.dart';

class SectionHeaderWidget extends StatefulWidget {
  const SectionHeaderWidget({
    super.key,
    String? title,
  }) : title = title ?? 'Background Information';

  final String title;

  @override
  State<SectionHeaderWidget> createState() => _SectionHeaderWidgetState();
}

class _SectionHeaderWidgetState extends State<SectionHeaderWidget> {
  late SectionHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SectionHeaderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(
            widget.title,
            'Background Information',
          ),
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                lineHeight: 1.35,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).titleMediumIsCustom,
              ),
        ),
        Divider(
          height: 16.0,
          thickness: 1.0,
          indent: 0.0,
          endIndent: 0.0,
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ].divide(const SizedBox(height: 4.0)),
    );
  }
}
