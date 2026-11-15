import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'report_block_unblock_model.dart';

export 'report_block_unblock_model.dart';

class ReportBlockUnblockWidget extends StatefulWidget {
  const ReportBlockUnblockWidget({super.key});

  static String routeName = 'ReportBlockUnblock';
  static String routePath = '/Report/Block/Unblock';

  @override
  State<ReportBlockUnblockWidget> createState() =>
      _ReportBlockUnblockWidgetState();
}

class _ReportBlockUnblockWidgetState extends State<ReportBlockUnblockWidget> {
  static const _reasons = [
    'Spam',
    'Harassment',
    'Inappropriate content',
    'Impersonation',
    'Hate speech',
    'Other',
  ];

  late ReportBlockUnblockModel _model;
  final _formKey = GlobalKey<FormState>();
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportBlockUnblockModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  void _showUnavailable(String feature) {
    showSnackbar(
      context,
      '$feature is not available yet. Please contact support if you feel unsafe.',
      backgroundColor: FlutterFlowTheme.of(context).error,
    );
  }

  void _submitReport() {
    if (_selectedReason == null) {
      showSnackbar(
        context,
        'Choose a reason for your report.',
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }
    if (_formKey.currentState?.validate() != true) return;
    _showUnavailable('User reporting');
  }

  Future<void> _requestBlock(bool block) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: block ? 'Block this user?' : 'Unblock this user?',
      message: block
          ? 'They will no longer be able to contact you.'
          : 'They will be able to contact you again.',
      confirmLabel: block ? 'Block' : 'Unblock',
      destructive: block,
    );
    if (confirmed && mounted) {
      _showUnavailable(block ? 'Blocking users' : 'Unblocking users');
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
        title: const Text('Safety tools'),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                'Report user',
                style: theme.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Tell us what happened. Reports should be reviewed privately by the safety team.',
                style: theme.bodyMedium.copyWith(
                  color: theme.secondaryText,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Reason',
                style: theme.labelLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _reasons
                    .map(
                      (reason) => ChoiceChip(
                        label: Text(reason),
                        selected: _selectedReason == reason,
                        onSelected: (_) =>
                            setState(() => _selectedReason = reason),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                minLines: 4,
                maxLines: 7,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Additional details (optional)',
                  alignLabelWithHint: true,
                  hintText: 'Share information that may help with the review.',
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Submit report'),
              ),
              const SizedBox(height: 28),
              Divider(color: theme.alternate),
              const SizedBox(height: 20),
              Text(
                'Contact controls',
                style: theme.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Blocking should immediately stop direct contact without notifying the other person.',
                style: theme.bodyMedium.copyWith(
                  color: theme.secondaryText,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _requestBlock(true),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: theme.error,
                  side: BorderSide(color: theme.error),
                ),
                icon: const Icon(Icons.block_rounded),
                label: const Text('Block user'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _requestBlock(false),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Unblock user'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
