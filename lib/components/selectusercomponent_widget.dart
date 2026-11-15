import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'selectusercomponent_model.dart';

export 'selectusercomponent_model.dart';

class SelectusercomponentWidget extends StatefulWidget {
  const SelectusercomponentWidget({super.key});

  @override
  State<SelectusercomponentWidget> createState() =>
      _SelectusercomponentWidgetState();
}

class _SelectusercomponentWidgetState extends State<SelectusercomponentWidget> {
  late SelectusercomponentModel _model;
  late Future<List<UsersRow>> _contacts;
  int? _busyUserId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectusercomponentModel());
    _contacts = _loadContacts();
  }

  Future<List<UsersRow>> _loadContacts() => UsersTable().queryRows(
        queryFn: (q) => q.neqOrNull('user_id', currentUserUid),
      );

  Future<void> _startChat(UsersRow contact) async {
    if (_busyUserId != null) return;
    setState(() => _busyUserId = contact.id);
    try {
      final currentUserId = (await ensureCurrentUserProfile())?.id;
      if (currentUserId == null) {
        if (mounted) {
          showSnackbar(
            context,
            'Complete your profile before starting a chat.',
            backgroundColor: FlutterFlowTheme.of(context).error,
          );
        }
        return;
      }

      // The database function verifies both identities, reuses an existing
      // one-to-one conversation, and creates the chat plus memberships in a
      // single transaction.
      await SupaFlow.client.rpc<int>(
        'start_direct_chat',
        params: {'target_profile_id': contact.id},
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error, stackTrace) {
      debugPrint('Unable to create chat: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        showSnackbar(
          context,
          'Could not start the chat. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) setState(() => _busyUserId = null);
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return SafeArea(
      top: false,
      child: Material(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .68,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.secondaryText.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Start a conversation',
                        style: theme.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: theme.alternate),
              Expanded(
                child: FutureBuilder<List<UsersRow>>(
                  future: _contacts,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AppErrorState(
                        onRetry: () => setState(() {
                          _contacts = _loadContacts();
                        }),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const AppShimmerList(itemCount: 5);
                    }
                    final contacts = snapshot.data!;
                    if (contacts.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.people_outline_rounded,
                        title: 'No contacts yet',
                        message: 'Other community members will appear here.',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: contacts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final busy = _busyUserId == contact.id;
                        return ListTile(
                          minTileHeight: 68,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: theme.alternate),
                          ),
                          tileColor: theme.secondaryBackground,
                          leading: AppNetworkAvatar(
                            url: contact.profilepicture,
                            semanticLabel:
                                '${contact.fullName ?? 'Contact'} profile photo',
                          ),
                          title: Text(
                            contact.fullName?.trim().isNotEmpty == true
                                ? contact.fullName!
                                : 'Community member',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.bodyLarge
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            contact.state?.trim().isNotEmpty == true
                                ? contact.state!
                                : 'Parent Partnership member',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: busy
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : const Icon(Icons.chevron_right_rounded),
                          onTap: busy ? null : () => _startChat(contact),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
