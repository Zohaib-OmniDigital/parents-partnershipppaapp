import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/chatmessages/chatmessages_widget.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'view_parent_profile_model.dart';
export 'view_parent_profile_model.dart';

class ViewParentProfileWidget extends StatefulWidget {
  const ViewParentProfileWidget({
    super.key,
    this.profileId,
    required this.profilepicture,
    required this.fullname,
    required this.isverified,
    required this.country,
    required this.state,
    required this.age,
    required this.gender,
    required this.bio,
  });

  final int? profileId;
  final String? profilepicture;
  final String? fullname;
  final bool? isverified;
  final String? country;
  final String? state;
  final String? age;
  final String? gender;
  final String? bio;

  static String routeName = 'ViewParentProfile';
  static String routePath = '/ViewParentProfile';

  @override
  State<ViewParentProfileWidget> createState() =>
      _ViewParentProfileWidgetState();
}

class _ViewParentProfileWidgetState extends State<ViewParentProfileWidget> {
  late ViewParentProfileModel _model;
  bool _isOpeningChat = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _openChat() async {
    final profileId = widget.profileId;
    if (profileId == null || _isOpeningChat) return;

    safeSetState(() => _isOpeningChat = true);
    try {
      final currentProfile = await ensureCurrentUserProfile();
      if (currentProfile == null || currentProfile.id == profileId) {
        throw StateError('A valid parent profile is required.');
      }

      final chatId = await SupaFlow.client.rpc<int>(
        'start_direct_chat',
        params: {'target_profile_id': profileId},
      );
      final chats = await AChatSummaryTable().queryRows(
        queryFn: (query) => query.eq('chat_id', chatId),
      );
      final chat = chats.firstOrNull;
      if (chat == null) {
        throw StateError('The conversation could not be loaded.');
      }

      if (!mounted) return;
      await context.pushNamed(
        ChatmessagesWidget.routeName,
        queryParameters: {
          'chatRow': serializeParam(chat, ParamType.SupabaseRow),
        },
      );
    } catch (error, stackTrace) {
      debugPrint('Unable to open chat from parent profile: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        showSnackbar(
          context,
          'Could not open this conversation. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) safeSetState(() => _isOpeningChat = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewParentProfileModel());

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
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFF4F6FF),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            title: Text(
              'View Parent Profile',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).headlineMediumFamily,
                    color: Colors.white,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                  ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20.0,
                          color: FlutterFlowTheme.of(context).tertiary,
                          offset: const Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 32.0, 24.0, 32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag:
                                        'parent-profile-${widget.profilepicture ?? widget.fullname ?? 'unknown'}',
                                    transitionOnUserGestures: true,
                                    child: AppNetworkAvatar(
                                      url: widget.profilepicture,
                                      size: 160,
                                      semanticLabel:
                                          '${widget.fullname ?? 'Parent'} profile photo',
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              widget.fullname,
                                              'Unknown',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumFamily,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumIsCustom,
                                                ),
                                          ),
                                          if (widget.isverified == true)
                                            Icon(
                                              Icons.verified_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 24.0,
                                            ),
                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget.country,
                                            'Not Specified',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLargeFamily,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 10.0, 0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget.state,
                                            'Not Specified',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 4.0)),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget.age,
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLargeFamily,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 12.0, 0.0, 0.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              widget.gender,
                                              'Not Specified',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, -1.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 24.0, 0.0, 0.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              widget.bio,
                                              'No bio provided',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: FilledButton.icon(
                                            onPressed:
                                                widget.profileId == null ||
                                                        _isOpeningChat
                                                    ? null
                                                    : _openChat,
                                            icon: _isOpeningChat
                                                ? const SizedBox.square(
                                                    dimension: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.chat_bubble_rounded,
                                                  ),
                                            label: Text(
                                              _isOpeningChat
                                                  ? 'Opening chat…'
                                                  : 'Message',
                                            ),
                                            style: FilledButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(52),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ].divide(const SizedBox(height: 16.0)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
