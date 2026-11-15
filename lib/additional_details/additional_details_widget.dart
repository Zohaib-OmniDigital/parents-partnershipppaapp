import '/backend/supabase/supabase.dart';
import '/components/section_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'additional_details_model.dart';
export 'additional_details_model.dart';

/// Create a professional mobile UI screen for the 'Additional Details &
/// Verification' page of the "Parents Partnership" app.
///
/// Top Header:
/// - Include a back arrow icon and the page title "Additional Details".
///
/// Section 1: Background Information
/// - Add a text field for "Previous Employment (Company Name & Role)".
/// - Add a text field for "Former Legal Names / Aliases (If any)".
///
/// Section 2: Face Verification (Camera Capture)
/// - Add a section title: "Identity Verification".
/// - Add a brief instructional text: "Please take a clear selfie to verify
/// your identity against your legal documents."
/// - Create a large, clean, circular placeholder element in the center
/// representing a camera preview window, featuring a dashed placeholder
/// outline.
/// - Inside or right below the circle, place a secondary button with a camera
/// icon labeled "Capture Selfie".
///
/// Footer/Bottom Area:
/// - Place a large, prominent, full-width primary button at the very bottom
/// labeled "Save & Return". Use a trustworthy solid deep blue color.
///
/// Aesthetic: Highly clean, spacious, using white and light blue accents to
/// highlight the secure camera verification zone.
class AdditionalDetailsWidget extends StatefulWidget {
  const AdditionalDetailsWidget({super.key});

  static String routeName = 'AdditionalDetails';
  static String routePath = '/additionalDetails';

  @override
  State<AdditionalDetailsWidget> createState() =>
      _AdditionalDetailsWidgetState();
}

class _AdditionalDetailsWidgetState extends State<AdditionalDetailsWidget> {
  late AdditionalDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdditionalDetailsModel());

    _model.uploadedFileUrl_uploadedSelfie = FFAppState().stateSelfieUrl;

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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).tertiary,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 24.0, 16.0, 24.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.safePop();
                            },
                          ),
                          Text(
                            'Additional Details',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleLargeFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  lineHeight: 1.27,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleLargeIsCustom,
                                ),
                          ),
                        ].divide(const SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.stylus,
                      PointerDeviceKind.unknown,
                    },
                  ),
                  child: Scrollbar(
                    controller: _model.columnScrollController,
                    child: SingleChildScrollView(
                      primary: false,
                      controller: _model.columnScrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      wrapWithModel(
                                        model: _model.sectionHeaderModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: const SectionHeaderWidget(
                                          title: 'Background Information',
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 16.0)),
                                  ),
                                  Text(
                                    'Identity Verification',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          lineHeight: 1.35,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    'Please take a clear selfie to verify your identity against your legal documents.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          lineHeight: 1.47,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                          FlutterFlowTheme.of(context).primary,
                                          FlutterFlowTheme.of(context).alternate
                                        ],
                                        stops: const [0.0, 1.0, 1.0],
                                        begin: const AlignmentDirectional(
                                            0.0, -1.0),
                                        end: const AlignmentDirectional(0, 1.0),
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 24.0, 0.0, 0.0),
                                            child: Container(
                                              width: 220.0,
                                              height: 220.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        9999.0),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.face_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 64.0,
                                                  ),
                                                ].divide(const SizedBox(
                                                    height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: const SizedBox(
                                            width: 0.0,
                                            height: 0.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(70.0, 0.0, 70.0, 24.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              final selectedMedia =
                                                  await selectMedia(
                                                storageFolderPath:
                                                    'uploadedSelfie',
                                                multiImage: false,
                                              );
                                              if (selectedMedia != null &&
                                                  selectedMedia.every((m) =>
                                                      validateFileFormat(
                                                          m.storagePath,
                                                          context))) {
                                                safeSetState(() => _model
                                                        .isDataUploading_uploadedSelfie =
                                                    true);
                                                var selectedUploadedFiles =
                                                    <FFUploadedFile>[];

                                                var downloadUrls = <String>[];
                                                try {
                                                  selectedUploadedFiles =
                                                      selectedMedia
                                                          .map((m) =>
                                                              FFUploadedFile(
                                                                name: m
                                                                    .storagePath
                                                                    .split('/')
                                                                    .last,
                                                                bytes: m.bytes,
                                                                height: m
                                                                    .dimensions
                                                                    ?.height,
                                                                width: m
                                                                    .dimensions
                                                                    ?.width,
                                                                blurHash:
                                                                    m.blurHash,
                                                                originalFilename:
                                                                    m.originalFilename,
                                                              ))
                                                          .toList();

                                                  downloadUrls =
                                                      await uploadSupabaseStorageFiles(
                                                    bucketName: 'verifications',
                                                    selectedFiles:
                                                        selectedMedia,
                                                  );
                                                } finally {
                                                  _model.isDataUploading_uploadedSelfie =
                                                      false;
                                                }
                                                if (selectedUploadedFiles
                                                            .length ==
                                                        selectedMedia.length &&
                                                    downloadUrls.length ==
                                                        selectedMedia.length) {
                                                  safeSetState(() {
                                                    _model.uploadedLocalFile_uploadedSelfie =
                                                        selectedUploadedFiles
                                                            .first;
                                                    _model.uploadedFileUrl_uploadedSelfie =
                                                        downloadUrls.first;
                                                  });
                                                } else {
                                                  safeSetState(() {});
                                                  return;
                                                }
                                              }

                                              if (!context.mounted) return;
                                              showSnackbar(
                                                context,
                                                'Selfie saved successfully!',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              );
                                            },
                                            text: 'Capture Selfie',
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              size: 24.0,
                                            ),
                                            options: FFButtonOptions(
                                              height: 54.74,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmallFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmallIsCustom,
                                                  ),
                                              elevation: 0.0,
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 24.0)),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.lock,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 18.0,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Your biometric data is encrypted and used only for legal verification purposes.',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      lineHeight: 1.38,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ].divide(const SizedBox(width: 8.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            36.0, 0.0, 36.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if (_model
                                            .uploadedFileUrl_uploadedSelfie
                                            .trim()
                                            .isEmpty) {
                                          showSnackbar(
                                            context,
                                            'Capture or upload a selfie before saving.',
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          );
                                          return;
                                        }
                                        FFAppState().stateSelfieUrl = _model
                                            .uploadedFileUrl_uploadedSelfie;
                                        safeSetState(() {});
                                        showSnackbar(
                                          context,
                                          'Verification details saved!',
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        );
                                        context.safePop();
                                      },
                                      text: 'Save & Return',
                                      icon: const Icon(
                                        Icons.verified_user_outlined,
                                        size: 22.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 42.94,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleSmallIsCustom,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(height: 32.0)),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
