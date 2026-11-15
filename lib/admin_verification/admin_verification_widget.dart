import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'admin_verification_model.dart';

export 'admin_verification_model.dart';

class AdminVerificationWidget extends StatefulWidget {
  const AdminVerificationWidget({super.key});

  static String routeName = 'AdminVerification';
  static String routePath = '/adminVerification';

  @override
  State<AdminVerificationWidget> createState() =>
      _AdminVerificationWidgetState();
}

class _AdminVerificationWidgetState extends State<AdminVerificationWidget> {
  late AdminVerificationModel _model;
  Future<List<UsersRow>>? _pendingUsers;
  bool _checkingAccess = true;
  bool _authorized = false;
  int? _approvingId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminVerificationModel());
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      final users = await UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      );
      final allowed = users.firstOrNull?.isAdmin == true;
      if (!mounted) return;
      setState(() {
        _authorized = allowed;
        _checkingAccess = false;
        if (allowed) _pendingUsers = _loadPendingUsers();
      });
      if (!allowed) {
        showSnackbar(
          context,
          'You do not have permission to view this page.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } catch (_) {
      if (mounted) setState(() => _checkingAccess = false);
    }
  }

  Future<List<UsersRow>> _loadPendingUsers() => UsersTable().queryRows(
        queryFn: (q) =>
            q.eqOrNull('verification_status', 'pending').order('created_at'),
      );

  Future<void> _refresh() async {
    if (!_authorized) return;
    final request = _loadPendingUsers();
    setState(() => _pendingUsers = request);
    await request;
  }

  Future<void> _approve(UsersRow user) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Approve verification?',
      message:
          '${user.fullName ?? 'This applicant'} will receive verified access.',
      confirmLabel: 'Approve',
    );
    if (!confirmed || !mounted) return;

    setState(() => _approvingId = user.id);
    try {
      await UsersTable().update(
        data: {
          'verification_status': 'verified',
          'is_verified': true,
        },
        matchingRows: (rows) => rows.eqOrNull('id', user.id),
      );
      if (mounted) {
        showSnackbar(context, '${user.fullName ?? 'User'} approved.');
        await _refresh();
      }
    } catch (_) {
      if (mounted) {
        showSnackbar(
          context,
          'Could not approve this verification. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) setState(() => _approvingId = null);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.safePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Verification queue'),
        actions: [
          IconButton(
            tooltip: 'Refresh applications',
            onPressed: _authorized ? _refresh : null,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _checkingAccess
            ? const AppShimmerList(itemCount: 4)
            : !_authorized
                ? AppEmptyState(
                    icon: Icons.lock_outline_rounded,
                    title: 'Admin access required',
                    message:
                        'This verification queue is only available to administrators.',
                    actionLabel: 'Go home',
                    onAction: () => context.goNamed(HomeWidget.routeName),
                  )
                : FutureBuilder<List<UsersRow>>(
                    future: _pendingUsers,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return AppErrorState(onRetry: _refresh);
                      }
                      if (!snapshot.hasData) {
                        return const AppShimmerList(itemCount: 4);
                      }
                      final applicants = snapshot.data!;
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pending applications',
                                            style: theme.titleLarge.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            applicants.length == 1
                                                ? '1 application needs review'
                                                : '${applicants.length} applications need review',
                                            style: theme.bodyMedium.copyWith(
                                              color: theme.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppStatusChip(
                                      label: '${applicants.length} pending',
                                      type: AppStatusType.warning,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (applicants.isEmpty)
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: AppEmptyState(
                                  icon: Icons.task_alt_rounded,
                                  title: 'Queue is clear',
                                  message:
                                      'There are no verification applications waiting for review.',
                                ),
                              )
                            else
                              SliverPadding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 28),
                                sliver: SliverList.separated(
                                  itemCount: applicants.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final user = applicants[index];
                                    final approving = _approvingId == user.id;
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                AppNetworkAvatar(
                                                  url: user.profilepicture,
                                                  size: 52,
                                                  semanticLabel:
                                                      '${user.fullName ?? 'Applicant'} profile photo',
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        user.fullName
                                                                    ?.trim()
                                                                    .isNotEmpty ==
                                                                true
                                                            ? user.fullName!
                                                            : 'Unnamed applicant',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.titleMedium
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        user.email ??
                                                            'No email provided',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.bodySmall
                                                            .copyWith(
                                                          color: theme
                                                              .secondaryText,
                                                        ),
                                                      ),
                                                      if (user.createdAt !=
                                                          null) ...[
                                                        const SizedBox(
                                                            height: 3),
                                                        Text(
                                                          'Submitted ${dateTimeFormat('relative', user.createdAt)}',
                                                          style: theme.bodySmall
                                                              .copyWith(
                                                            color: theme
                                                                .secondaryText,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            FilledButton.icon(
                                              onPressed: approving
                                                  ? null
                                                  : () => _approve(user),
                                              icon: approving
                                                  ? const SizedBox.square(
                                                      dimension: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .verified_user_rounded,
                                                      size: 19,
                                                    ),
                                              label: Text(approving
                                                  ? 'Approving…'
                                                  : 'Approve verification'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
