import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'parent_profiles_model.dart';
export 'parent_profiles_model.dart';

class ParentProfilesWidget extends StatefulWidget {
  const ParentProfilesWidget({super.key});

  static String routeName = 'ParentProfiles';
  static String routePath = '/ParentProfiles';

  @override
  State<ParentProfilesWidget> createState() => _ParentProfilesWidgetState();
}

class _ParentProfilesWidgetState extends State<ParentProfilesWidget> {
  late ParentProfilesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParentProfilesModel());

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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).alternate,
            automaticallyImplyLeading: false,
            leading: Align(
              alignment: const AlignmentDirectional(-1.0, 1.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: FlutterFlowIconButton(
                  buttonSize: 44.0,
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(HomeWidget.routeName);
                  },
                ),
              ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                ScrollConfiguration(
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
                    controller: _model.columnController,
                    child: SingleChildScrollView(
                      controller: _model.columnController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Stack(
                                        children: [
                                          Stack(
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                            24.0, 0.0),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'Parent Finder',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      22.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMediumIsCustom,
                                                                ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        24.0,
                                                                        0.0,
                                                                        36.0),
                                                                child: FutureBuilder<
                                                                    List<
                                                                        UsersRow>>(
                                                                  future: UsersTable()
                                                                      .queryRows(
                                                                    queryFn: (q) =>
                                                                        q.neqOrNull(
                                                                      'user_id',
                                                                      currentUserUid,
                                                                    ),
                                                                  ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return const AppErrorState();
                                                                    }
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return const AppShimmerList(
                                                                        itemCount:
                                                                            4,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                      );
                                                                    }
                                                                    List<UsersRow>
                                                                        listViewUsersRowList =
                                                                        snapshot
                                                                            .data!;

                                                                    if (listViewUsersRowList
                                                                        .isEmpty) {
                                                                      return const AppEmptyState(
                                                                        icon: Icons
                                                                            .group_outlined,
                                                                        title:
                                                                            'No parent profiles yet',
                                                                        message:
                                                                            'New parent profiles will appear here when they join the community.',
                                                                      );
                                                                    }

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          listViewUsersRowList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              listViewIndex) {
                                                                        final listViewUsersRow =
                                                                            listViewUsersRowList[listViewIndex];
                                                                        return Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              16.0,
                                                                              0.0,
                                                                              16.0,
                                                                              0.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              Material(
                                                                                color: Colors.transparent,
                                                                                elevation: 2.0,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(16.0),
                                                                                ),
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(16.0),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Material(
                                                                                color: Colors.transparent,
                                                                                elevation: 2.0,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(16.0),
                                                                                ),
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        blurRadius: 20.0,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        offset: const Offset(
                                                                                          10.0,
                                                                                          10.0,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.circular(16.0),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Stack(
                                                                                              children: [
                                                                                                Hero(
                                                                                                  tag: valueOrDefault<String>(
                                                                                                    listViewUsersRow.profilepicture,
                                                                                                    'parent-$listViewIndex',
                                                                                                  ),
                                                                                                  transitionOnUserGestures: true,
                                                                                                  child: AppNetworkAvatar(
                                                                                                    url: listViewUsersRow.profilepicture,
                                                                                                    size: 70.0,
                                                                                                    semanticLabel: 'Parent profile photo',
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Flexible(
                                                                                                        child: Text(
                                                                                                          valueOrDefault<String>(
                                                                                                            listViewUsersRow.fullName,
                                                                                                            'Parent',
                                                                                                          ),
                                                                                                          maxLines: 1,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      if (listViewUsersRow.isVerified == true)
                                                                                                        Icon(
                                                                                                          Icons.verified_rounded,
                                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                                          size: 14.0,
                                                                                                        ),
                                                                                                    ].divide(const SizedBox(width: 6.0)),
                                                                                                  ),
                                                                                                ].divide(const SizedBox(height: 4.0)),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 12.0)),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                              child: FFButtonWidget(
                                                                                                onPressed: () async {
                                                                                                  context.pushNamed(
                                                                                                    ViewParentProfileWidget.routeName,
                                                                                                    queryParameters: {
                                                                                                      'profileId': serializeParam(
                                                                                                        listViewUsersRow.id,
                                                                                                        ParamType.int,
                                                                                                      ),
                                                                                                      'profilepicture': serializeParam(
                                                                                                        listViewUsersRow.profilepicture,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'fullname': serializeParam(
                                                                                                        listViewUsersRow.fullName,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'isverified': serializeParam(
                                                                                                        listViewUsersRow.isVerified,
                                                                                                        ParamType.bool,
                                                                                                      ),
                                                                                                      'country': serializeParam(
                                                                                                        listViewUsersRow.country,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'state': serializeParam(
                                                                                                        listViewUsersRow.state,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'age': serializeParam(
                                                                                                        listViewUsersRow.age,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'gender': serializeParam(
                                                                                                        listViewUsersRow.gender,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'bio': serializeParam(
                                                                                                        listViewUsersRow.bio,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                    }.withoutNulls,
                                                                                                  );
                                                                                                },
                                                                                                text: 'View Profile',
                                                                                                options: FFButtonOptions(
                                                                                                  width: 160.0,
                                                                                                  height: 48.0,
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                        color: FlutterFlowTheme.of(context).alternate,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                      ),
                                                                                                  elevation: 0.0,
                                                                                                  borderRadius: BorderRadius.circular(24.0),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 12.0)),
                                                                                        ),
                                                                                      ].divide(const SizedBox(height: 12.0)),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ].divide(const SizedBox(height: 16.0)),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
