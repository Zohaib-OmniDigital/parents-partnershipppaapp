import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

export 'post_bottom_sheet_model.dart';

class PostBottomSheetWidget extends StatefulWidget {
  const PostBottomSheetWidget({
    super.key,
    String? titleHint,
    String? contentHint,
    String? buttonLabel,
    required this.currentUser,
  })  : titleHint = titleHint ?? '',
        contentHint = contentHint ?? '',
        buttonLabel = buttonLabel ?? '';

  final String titleHint;
  final String contentHint;
  final String buttonLabel;
  final String? currentUser;

  @override
  State<PostBottomSheetWidget> createState() => _PostBottomSheetWidgetState();
}

class _PostBottomSheetWidgetState extends State<PostBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late Future<UsersRow?> _profileFuture;
  bool _publishing = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<UsersRow?> _loadProfile() => ensureCurrentUserProfile();

  Future<void> _publish(UsersRow profile) async {
    if (!_formKey.currentState!.validate() || _publishing) return;
    setState(() => _publishing = true);
    try {
      await PostsTable().insert({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'user_id': currentUserUid,
        'user_name': profile.fullName,
        'user_avatar': profile.profilepicture,
      });
      if (mounted) {
        showSnackbar(context, 'Your post has been published.');
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        showSnackbar(
          context,
          'Could not publish your post. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
        child: FutureBuilder<UsersRow?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 420,
                child: AppErrorState(
                  onRetry: () => setState(() {
                    _profileFuture = _loadProfile();
                  }),
                ),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 420,
                child: AppShimmerList(itemCount: 3),
              );
            }
            final profile = snapshot.data;
            if (profile == null) {
              return const SizedBox(
                height: 420,
                child: AppEmptyState(
                  icon: Icons.person_outline_rounded,
                  title: 'Complete your profile first',
                  message:
                      'A profile is required before you can publish a post.',
                ),
              );
            }

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.secondaryText.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Create post',
                            style: theme.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          onPressed:
                              _publishing ? null : () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    Text(
                      'Share a question, idea, or helpful experience with the community.',
                      style: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      autofocus: false,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      maxLength: 120,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: widget.titleHint.trim().isEmpty
                            ? 'What would you like to discuss?'
                            : widget.titleHint,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter a title.'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      minLines: 4,
                      maxLines: 7,
                      maxLength: 1500,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Post',
                        hintText: widget.contentHint.trim().isEmpty
                            ? 'Add enough detail to help others respond…'
                            : widget.contentHint,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Write something to share.'
                              : null,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: _publishing ? null : () => _publish(profile),
                      icon: _publishing
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 19),
                      label: Text(
                        _publishing
                            ? 'Publishing…'
                            : (widget.buttonLabel.trim().isEmpty
                                ? 'Publish post'
                                : widget.buttonLabel),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
