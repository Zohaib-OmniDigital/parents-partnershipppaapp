import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'info_banner_model.dart';
export 'info_banner_model.dart';

class InfoBannerWidget extends StatefulWidget {
  const InfoBannerWidget({
    super.key,
    String? message,
  }) : message = message ??
            'Legal Identity Verification. To ensure community safety, you must provide your real legal information exactly as it appears on your ID. Aliases, nicknames, or fake identities are strictly prohibited.';

  final String message;

  @override
  State<InfoBannerWidget> createState() => _InfoBannerWidgetState();
}

class _InfoBannerWidgetState extends State<InfoBannerWidget> {
  late InfoBannerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfoBannerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(24.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).info,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  valueOrDefault<String>(
                    widget.message,
                    'Legal Identity Verification. To ensure community safety, you must provide your real legal information exactly as it appears on your ID. Aliases, nicknames, or fake identities are strictly prohibited.',
                  ),
                  maxLines: 5,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodySmallFamily,
                        letterSpacing: 0.0,
                        lineHeight: 1.38,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodySmallIsCustom,
                      ),
                ),
              ),
            ].divide(const SizedBox(width: 16.0)),
          ),
        ),
      ),
    );
  }
}
