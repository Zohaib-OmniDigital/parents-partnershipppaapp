import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'pending_status_model.dart';
export 'pending_status_model.dart';

/// Create a professional, minimalist, and trustworthy 'Verification Pending'
/// mobile app screen for a family-focused US application.
///
/// The layout should be centered with a clean white background.
///
/// Header: Verification Pending.
///
/// Icon: A subtle, modern 'Pending' or 'Clock' icon in the center (Use
/// primary brand color).
///
/// Body Text: 'Thank you for submitting your identity documents. Our team is
/// currently reviewing your information to ensure community safety. This
/// process usually takes 24-48 hours.'
///
/// UI Style: Use rounded buttons and clean typography. Ensure the look is
/// secure and professional.
class PendingStatusWidget extends StatefulWidget {
  const PendingStatusWidget({super.key});

  static String routeName = 'PendingStatus';
  static String routePath = '/pendingStatus';

  @override
  State<PendingStatusWidget> createState() => _PendingStatusWidgetState();
}

class _PendingStatusWidgetState extends State<PendingStatusWidget> {
  late PendingStatusModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingStatusModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).alternate,
          automaticallyImplyLeading: false,
          actions: [
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).tertiary,
              icon: Icon(
                Icons.close,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 26.0,
              ),
              onPressed: () async {
                context.goNamed(HomeWidget.routeName);
              },
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 64.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: const Color(0x1A283D96),
                            borderRadius: BorderRadius.circular(9999.0),
                            shape: BoxShape.rectangle,
                          ),
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.schedule_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 64.0,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Verification Pending',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    lineHeight: 1.25,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineMediumIsCustom,
                                  ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300.0,
                              ),
                              child: Text(
                                'Thank you for submitting your identity documents. Our team is currently reviewing your information to ensure community safety. This process usually takes 24-48 hours.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.5,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                              ),
                            ),
                          ].divide(const SizedBox(height: 16.0)),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.goNamed(HomeWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 16.0, 24.0, 16.0),
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified_user_rounded,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 18.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Security Review in Progress',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              letterSpacing: 0.0,
                                              lineHeight: 1.33,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelLargeIsCustom,
                                            ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 24.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 20.0,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'You\'ll receive a push notification as soon as your account is ready.',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmallFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            lineHeight: 1.38,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodySmallIsCustom,
                                          ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 16.0)),
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
