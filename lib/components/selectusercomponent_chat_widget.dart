import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'selectusercomponent_chat_model.dart';

export 'selectusercomponent_chat_model.dart';

class SelectusercomponentChatWidget extends StatefulWidget {
  const SelectusercomponentChatWidget({
    super.key,
    required this.currrentChatRow,
  });

  final AChatSummaryRow? currrentChatRow;

  @override
  State<SelectusercomponentChatWidget> createState() =>
      _SelectusercomponentChatWidgetState();
}

class _SelectusercomponentChatWidgetState
    extends State<SelectusercomponentChatWidget> {
  late SelectusercomponentChatModel _model;
  late Future<List<UsersRow>> _contacts;
  int? _busyUserId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectusercomponentChatModel());
    _contacts = _loadContacts();
  }

  Future<List<UsersRow>> _loadContacts() async {
    final rows = await UsersTable().queryRows(
      queryFn: (q) => q.neqOrNull('user_id', currentUserUid),
    );
    final existingIds = widget.currrentChatRow?.userIds.toSet() ?? <int>{};
    return rows.where((user) => !existingIds.contains(user.id)).toList();
  }

  Future<void> _addParticipant(UsersRow contact) async {
    final chatId = widget.currrentChatRow?.chatId;
    if (chatId == null || _busyUserId != null) return;
    setState(() => _busyUserId = contact.id);
    try {
      await SupaFlow.client.rpc<void>(
        'add_chat_participant',
        params: {
          'target_chat_id': chatId,
          'target_profile_id': contact.id,
        },
      );
      if (mounted) {
        showSnackbar(context, '${contact.fullName ?? 'Member'} added to chat.');
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        showSnackbar(
          context,
          'Could not add this person. Please try again.',
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
                        'Add a participant',
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
                        icon: Icons.group_rounded,
                        title: 'Everyone is already here',
                        message: 'There are no more contacts to add.',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
                              : const Icon(Icons.person_add_alt_1_rounded),
                          onTap: busy ? null : () => _addParticipant(contact),
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
