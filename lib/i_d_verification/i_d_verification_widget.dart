import '/backend/supabase/supabase.dart';
import '/components/info_banner_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'i_d_verification_model.dart';
export 'i_d_verification_model.dart';

/// Create a clean, secure, and modern mobile-first ID Verification page for a
/// US-focused community application.
///
/// The layout must be highly user-friendly, responsive, and use a trustworthy
/// theme.
///
/// - Top Info Banner: Design a prominent, light-blue or soft-grey background
/// container at the top. Inside, feature a security icon and a clear text
/// message: 'Legal Identity Verification. To ensure community safety, you
/// must provide your real legal information exactly as it appears on your ID.
/// Aliases, nicknames, or fake identities are strictly prohibited.'
/// - Legal Details Form: Below the banner, create a neatly spaced vertical
/// form containing these text fields with floating labels:
///
/// 'Legal First Name' (Text input)
///
/// 'Legal Last Name' (Text input)
///
/// 'Date of Birth' (Date picker or masked text input formatted as MM/DD/YYYY)
///
/// 'Residential Address' (Text input)
/// - ID Upload Section: Below the form, add a stylized upload container with
/// a dashed border, a prominent cloud-upload icon, and descriptive text:
/// 'Upload Government-Issued ID. Please upload a clear photo of the front and
/// back of your official ID card or Driver's License.'
/// - Action Button: At the very bottom, place a fixed or full-width primary
/// button labeled 'Submit for Review'. Ensure the page has 16px padding all
/// around and smooth spacing to prevent any pixel overflow on smaller
/// devices.
class IDVerificationWidget extends StatefulWidget {
  const IDVerificationWidget({super.key});

  static String routeName = 'IDVerification';
  static String routePath = '/Verificationpage1';

  @override
  State<IDVerificationWidget> createState() => _IDVerificationWidgetState();
}

class _IDVerificationWidgetState extends State<IDVerificationWidget> {
  late IDVerificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IDVerificationModel());

    _model.uploadedFileUrl_uploadDataVya = FFAppState().stateIdUrl;

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
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              context.safePop();
                            },
                          ),
                          Text(
                            'ID Verification',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleLargeFamily,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
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
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
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
                                  Container(
                                    decoration: const BoxDecoration(),
                                    child: wrapWithModel(
                                      model: _model.infoBannerModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: const InfoBannerWidget(
                                        message:
                                            'Legal Identity Verification. To ensure community safety, you must provide your real legal information exactly as it appears on your ID. Aliases, nicknames, or fake identities are strictly prohibited.',
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Legal Details',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMediumFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              lineHeight: 1.35,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleMediumIsCustom,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 16.0)),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Identity Document',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMediumFamily,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  lineHeight: 1.35,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleMediumIsCustom,
                                                ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 160.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 1.0,
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
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    final selectedMedia =
                                                        await selectMediaWithSourceBottomSheet(
                                                      context: context,
                                                      storageFolderPath:
                                                          'verifications',
                                                      allowPhoto: true,
                                                    );
                                                    if (selectedMedia == null ||
                                                        selectedMedia.isEmpty) {
                                                      return;
                                                    }
                                                    if (selectedMedia.every(
                                                        (m) =>
                                                            validateFileFormat(
                                                                m.storagePath,
                                                                context))) {
                                                      safeSetState(() => _model
                                                              .isDataUploading_uploadDataVya =
                                                          true);
                                                      var selectedUploadedFiles =
                                                          <FFUploadedFile>[];

                                                      var downloadUrls =
                                                          <String>[];
                                                      try {
                                                        selectedUploadedFiles =
                                                            selectedMedia
                                                                .map((m) =>
                                                                    FFUploadedFile(
                                                                      name: m
                                                                          .storagePath
                                                                          .split(
                                                                              '/')
                                                                          .last,
                                                                      bytes: m
                                                                          .bytes,
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
                                                          bucketName:
                                                              'verifications',
                                                          selectedFiles:
                                                              selectedMedia,
                                                        );
                                                      } catch (error) {
                                                        if (context.mounted) {
                                                          showSnackbar(
                                                            context,
                                                            'Could not upload the ID image. Please try again.',
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                          );
                                                        }
                                                        debugPrint(
                                                            'ID upload failed: $error');
                                                        return;
                                                      } finally {
                                                        _model.isDataUploading_uploadDataVya =
                                                            false;
                                                      }
                                                      if (selectedUploadedFiles
                                                                  .length ==
                                                              selectedMedia
                                                                  .length &&
                                                          downloadUrls.length ==
                                                              selectedMedia
                                                                  .length) {
                                                        safeSetState(() {
                                                          _model.uploadedLocalFile_uploadDataVya =
                                                              selectedUploadedFiles
                                                                  .first;
                                                          _model.uploadedFileUrl_uploadDataVya =
                                                              downloadUrls
                                                                  .first;
                                                        });
                                                      } else {
                                                        safeSetState(() {});
                                                        return;
                                                      }
                                                    }

                                                    if (!context.mounted) return;
                                                    showSnackbar(
                                                      context,
                                                      'Successfully Uploaded',
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 48.0,
                                                    child: Icon(
                                                      _model
                                                              .isDataUploading_uploadDataVya
                                                          ? Icons
                                                              .hourglass_top_rounded
                                                          : _model.uploadedFileUrl_uploadDataVya
                                                                  .isNotEmpty
                                                              ? Icons
                                                                  .check_circle_rounded
                                                              : Icons
                                                                  .cloud_upload_rounded,
                                                      color: _model
                                                              .uploadedFileUrl_uploadDataVya
                                                              .isNotEmpty
                                                          ? Colors.green
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 32.0,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  _model.uploadedFileUrl_uploadDataVya
                                                          .isNotEmpty
                                                      ? 'ID image selected'
                                                      : 'Upload Government-Issued ID',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmallFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmallIsCustom,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  child: Text(
                                                    'Please upload a clear photo of the front and back of your official ID card or Driver\'s License.',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmallFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.38,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmallIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 16.0)),
                                      ),
                                    ],
                                  ),
                                ].divide(const SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 14.0,
                              ),
                              Text(
                                'Your data is encrypted and stored securely.',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelSmallFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.27,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelSmallIsCustom,
                                    ),
                              ),
                            ].divide(const SizedBox(width: 4.0)),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                70.0, 36.0, 70.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_model.uploadedFileUrl_uploadDataVya
                                    .trim()
                                    .isEmpty) {
                                  showSnackbar(
                                    context,
                                    'Upload a clear photo of your ID before saving.',
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  );
                                  return;
                                }
                                FFAppState().stateIdUrl =
                                    _model.uploadedFileUrl_uploadDataVya;
                                safeSetState(() {});
                                context.safePop();
                              },
                              text: 'Save & Return',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      child: const SizedBox(
                        width: 0.0,
                        height: 0.0,
                      ),
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
