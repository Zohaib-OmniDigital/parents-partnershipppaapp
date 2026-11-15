import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/components/post_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'feedforum_model.dart';
export 'feedforum_model.dart';

/// Create a clean and minimal mobile UI for a 'ForumsFeed' screen in a parent
/// partnership app.
///
/// Strictly follow this structure using basic FlutterFlow containers and rows
/// (No complex components):
///
/// 1. TOP APP BAR:
/// - A clean top row with a Back Arrow icon button on the left.
/// - Center Title: "Forums" in Bold, Dark Text.
/// - Right Side: A rounded Floating Action Button (FAB) or Icon Button with a
/// "+" (Plus) symbol to "Create Post".
///
/// 2. MAIN BODY (SCROLLABLE LIST):
/// - A vertical scrolling ListView container filling the screen width with a
/// 12px padding on all sides.
///
/// 3. FORUM POST CARD (SINGLE ITEM CONTAINER):
/// Inside the ListView, create a repeatable "Card Container" with the
/// following flat design:
/// - Background: Pure White or light off-white (#F8F9FA).
/// - Borders: Rounded corners (12px) with a subtle, soft grey border outline
/// (No heavy shadows).
/// - Inside Padding: 16px padding on all sides.
///
/// 4. INSIDE THE POST CARD CONTAINER (Top to Bottom Layout):
/// - TOP ROW (User Profile Row): A small 36x36px circular avatar placeholder
/// image on the left. Next to it, a vertical Column containing: Text 1 (User
/// Name, bold, 14px) and Text 2 (Time dynamic placeholder like "2 hours ago",
/// grey, 12px).
/// - MIDDLE COLUMN (Post Content): A 12px vertical spacing, then a Title Text
/// ("Post Title Here", Bold, 16px, Max Lines: 1), followed by a Content Body
/// Text ("Post body description snippet goes here...", Regular, 14px, Max
/// Lines: 3).
/// - BOTTOM ROW (Interaction Bar): A horizontal row with MainAxisAlignment
/// set to Space-Between.
///   * Left Side: A small horizontal Row with a Thumbs-Up/Heart Icon and a
/// "Likes Count" text label.
///   * Right Side: A clickable Horizontal Row or small flat button with a
/// Speech Bubble Icon and a text label "Reply" or "Comments" (This is where
/// the user will click to view the full post and reply).
///
/// Keep the color palette minimal: Deep Primary Blue/Indigo for active
/// elements, Slate Black for main text, and Light Grey for backgrounds and
/// secondary elements.
class FeedforumWidget extends StatefulWidget {
  const FeedforumWidget({super.key});

  static String routeName = 'feedforum';
  static String routePath = '/feedforum';

  @override
  State<FeedforumWidget> createState() => _FeedforumWidgetState();
}

class _FeedforumWidgetState extends State<FeedforumWidget> {
  late FeedforumModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshPosts() async {
    safeSetState(() => _model.requestCompleter = null);
    await _model.waitForRequestCompleted(maxWait: 5000);
  }

  Future<void> _showCreatePost() async {
    final created = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const PostBottomSheetWidget(
            currentUser: '',
            titleHint: '',
            contentHint: '',
            buttonLabel: '',
          ),
        ),
      ),
    );
    if (created == true && mounted) await _refreshPosts();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedforumModel());

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
                color: FlutterFlowTheme.of(context).alternate,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.safePop();
                            },
                          ),
                          Text(
                            'Forums',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleLargeFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  lineHeight: 1.27,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleLargeIsCustom,
                                ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 44.0,
                            fillColor: Colors.transparent,
                            icon: const Icon(
                              Icons.add_circle_rounded,
                              color: Color(0xFF3F51B5),
                              size: 28.0,
                            ),
                            onPressed: () async {
                              await _showCreatePost();
                            },
                          ),
                        ],
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
                child: FutureBuilder<List<PostsRow>>(
                  future:
                      (_model.requestCompleter ??= Completer<List<PostsRow>>()
                            ..complete(PostsTable().queryRows(
                              queryFn: (q) =>
                                  q.order('created_at', ascending: false),
                            )))
                          .future,
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (snapshot.hasError) {
                      return AppErrorState(
                        onRetry: () => safeSetState(
                          () => _model.requestCompleter = null,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const AppShimmerList();
                    }
                    List<PostsRow> listViewPostsRowList = snapshot.data!;

                    if (listViewPostsRowList.isEmpty) {
                      return AppEmptyState(
                        icon: Icons.forum_outlined,
                        title: 'No discussions yet',
                        message:
                            'Be the first parent to start a helpful conversation.',
                        actionLabel: 'Create a post',
                        onAction: _showCreatePost,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshPosts,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: listViewPostsRowList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewPostsRow =
                              listViewPostsRowList[listViewIndex];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(minHeight: 196),
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: const Color(0xFFE4E8F0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 24.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AppNetworkAvatar(
                                              url: listViewPostsRow.userAvatar,
                                              size: 36,
                                              semanticLabel:
                                                  'Post author photo',
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    listViewPostsRow.userName,
                                                    'Name',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        lineHeight: 1.47,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                Text(
                                                  dateTimeFormat(
                                                    'relative',
                                                    listViewPostsRow.createdAt,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        lineHeight: 1.47,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ].divide(const SizedBox(width: 16.0)),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                listViewPostsRow.title,
                                                'Title',
                                              ),
                                              maxLines: 1,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    lineHeight: 1.47,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                listViewPostsRow.content,
                                                'Content',
                                              ),
                                              maxLines: 3,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    lineHeight: 1.47,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 4.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24.0, 0.0, 0.0, 36.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (listViewPostsRow.userId ==
                                                    currentUserUid)
                                                  Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            1.0, -1.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        final confirmed =
                                                            await showConfirmationDialog(
                                                          context,
                                                          title: 'Delete post?',
                                                          message:
                                                              'This post will be permanently removed.',
                                                          confirmLabel:
                                                              'Delete',
                                                          destructive: true,
                                                        );
                                                        if (!confirmed ||
                                                            !context.mounted) {
                                                          return;
                                                        }
                                                        try {
                                                          await PostsTable()
                                                              .delete(
                                                            matchingRows:
                                                                (rows) => rows
                                                                    .eqOrNull(
                                                              'id',
                                                              listViewPostsRow
                                                                  .id,
                                                            ),
                                                          );
                                                          if (context.mounted) {
                                                            showSnackbar(
                                                                context,
                                                                'Post deleted.');
                                                            await _refreshPosts();
                                                          }
                                                        } catch (_) {
                                                          if (context.mounted) {
                                                            showSnackbar(
                                                              context,
                                                              'Could not delete this post. Please try again.',
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.delete_sharp,
                                                        color:
                                                            Color(0xFF3F51B5),
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                              ].divide(
                                                  const SizedBox(width: 4.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 16.0)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
