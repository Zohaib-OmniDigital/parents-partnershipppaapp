import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'verificationpage2_model.dart';

export 'verificationpage2_model.dart';

class Verificationpage2Widget extends StatefulWidget {
  const Verificationpage2Widget({super.key});

  static String routeName = 'Verificationpage2';
  static String routePath = '/verificationpage2';

  @override
  State<Verificationpage2Widget> createState() =>
      _Verificationpage2WidgetState();
}

class _Verificationpage2WidgetState extends State<Verificationpage2Widget> {
  static const _stripePaymentLink =
      'https://buy.stripe.com/eVq9AV7849JBcB3erY5ZC0d';

  late Verificationpage2Model _model;
  bool _consentAccepted = false;
  bool _submitting = false;
  bool _uploadingPoliceClearance = false;
  String _policeClearancePath = '';
  String _policeClearanceFilename = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Verificationpage2Model());
    _loadExistingApplication();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<String> get _missingSections {
    final state = FFAppState();
    return [
      if (state.stateIdUrl.trim().isEmpty) 'ID verification',
      if (state.stateLegalName.trim().isEmpty || state.stateDOB.trim().isEmpty)
        'Personal identification',
      if (state.stateAddress.trim().isEmpty ||
          state.stateCountry.trim().isEmpty ||
          state.stateState.trim().isEmpty ||
          state.stateZip.trim().isEmpty)
        'Address history',
      if (state.stateSelfieUrl.trim().isEmpty) 'Selfie verification',
      if (_policeClearancePath.trim().isEmpty) 'Police Clearance Certificate',
    ];
  }

  Future<void> _loadExistingApplication() async {
    if (currentUserUid.isEmpty) return;
    try {
      final rows = await BackgroundChecksTable().querySingleRow(
        queryFn: (query) => query.eqOrNull('user_id', currentUserUid),
      );
      final application = rows.firstOrNull;
      if (!mounted || application == null) return;
      setState(() {
        _policeClearancePath = application.policeClearancePath ?? '';
        _policeClearanceFilename = application.policeClearanceFilename ?? '';
      });
    } catch (error) {
      debugPrint('Could not load the background-check draft: $error');
    }
  }

  Future<void> _openStripeCheckout() async {
    if (currentUserUid.isEmpty) {
      showSnackbar(context, 'Please sign in before starting payment.',
          backgroundColor: FlutterFlowTheme.of(context).error);
      return;
    }

    final baseUri = Uri.parse(_stripePaymentLink);
    final checkoutUri = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'client_reference_id': currentUserUid,
    });
    final opened = await launchUrl(
      checkoutUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      showSnackbar(context, 'Could not open Stripe Checkout.',
          backgroundColor: FlutterFlowTheme.of(context).error);
    }
  }

  Future<void> _pickAndUploadPoliceClearance() async {
    if (_uploadingPoliceClearance || currentUserUid.isEmpty) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      withData: true,
    );
    final file =
        result == null || result.files.isEmpty ? null : result.files.first;
    if (file == null) return;
    if (file.bytes == null) {
      if (mounted) {
        showSnackbar(context, 'Could not read the selected document.',
            backgroundColor: FlutterFlowTheme.of(context).error);
      }
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      if (mounted) {
        showSnackbar(context, 'The document must be 10 MB or smaller.',
            backgroundColor: FlutterFlowTheme.of(context).error);
      }
      return;
    }

    final extension = file.extension?.toLowerCase() ?? 'pdf';
    final storagePath =
        '$currentUserUid/police-clearance-${DateTime.now().millisecondsSinceEpoch}.$extension';
    final contentType = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      _ => 'image/jpeg',
    };

    setState(() => _uploadingPoliceClearance = true);
    try {
      await SupaFlow.client.storage
          .from('background-check-documents')
          .uploadBinary(
            storagePath,
            file.bytes!,
            fileOptions: FileOptions(contentType: contentType),
          );
      if (!mounted) return;
      setState(() {
        _policeClearancePath = storagePath;
        _policeClearanceFilename = file.name;
      });
      showSnackbar(context, 'Police Clearance Certificate uploaded.');
    } catch (error) {
      debugPrint('Police Clearance upload failed: $error');
      if (mounted) {
        showSnackbar(context, 'Document upload failed. Please try again.',
            backgroundColor: FlutterFlowTheme.of(context).error);
      }
    } finally {
      if (mounted) setState(() => _uploadingPoliceClearance = false);
    }
  }

  Future<void> _submit(UsersRow? user) async {
    if (_submitting) return;
    if (currentUserUid.isEmpty || user == null) {
      showSnackbar(context, 'Your profile was not found. Please sign in again.',
          backgroundColor: FlutterFlowTheme.of(context).error);
      return;
    }
    if (user.backgroundCheckPaymentStatus?.toLowerCase() != 'paid') {
      showSnackbar(context, 'Complete the \$39.99 Stripe payment first.',
          backgroundColor: FlutterFlowTheme.of(context).error);
      return;
    }
    final missing = _missingSections;
    if (missing.isNotEmpty) {
      showSnackbar(context, 'Complete: ${missing.join(', ')}.',
          backgroundColor: FlutterFlowTheme.of(context).error);
      return;
    }
    if (!_consentAccepted) {
      showSnackbar(context, 'Accept the authorization before submitting.',
          backgroundColor: FlutterFlowTheme.of(context).error);
      return;
    }

    setState(() => _submitting = true);
    final state = FFAppState();
    final data = <String, dynamic>{
      'user_id': currentUserUid,
      'full_legal_name': state.stateLegalName.trim(),
      'date_of_birth': state.stateDOB.trim(),
      'current_address': state.stateAddress.trim(),
      // This spelling matches the existing database schema.
      'contry': state.stateCountry.trim(),
      'state': state.stateState.trim(),
      'zip_code': state.stateZip.trim(),
      'selfie_url': state.stateSelfieUrl.trim(),
      'id_document_url': state.stateIdUrl.trim(),
      'police_clearance_path': _policeClearancePath.trim(),
      'police_clearance_filename': _policeClearanceFilename.trim(),
    };

    try {
      final existing = await BackgroundChecksTable().querySingleRow(
        queryFn: (rows) => rows.eqOrNull('user_id', currentUserUid),
      );
      if (existing.isEmpty) {
        await BackgroundChecksTable().insert(data);
      } else {
        await BackgroundChecksTable().update(
          data: data,
          matchingRows: (rows) => rows.eqOrNull('user_id', currentUserUid),
        );
      }
      await SupaFlow.client.functions.invoke('submit-background-check');

      state.userStatus = 'pending';
      state.stateLegalName = '';
      state.stateDOB = '';
      state.stateAddress = '';
      state.stateCountry = '';
      state.stateState = '';
      state.stateZip = '';
      state.stateIdUrl = '';
      state.stateSelfieUrl = '';

      if (!mounted) return;
      showSnackbar(
          context, 'Verification submitted. You can continue using the app.',
          backgroundColor: FlutterFlowTheme.of(context).secondary);
      context.goNamed(HomeWidget.routeName);
    } catch (error) {
      if (!mounted) return;
      debugPrint('Verification submission failed: $error');
      showSnackbar(context, 'Submission failed. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    return FutureBuilder<List<UsersRow>>(
      future: UsersTable().querySingleRow(
        queryFn: (rows) => rows.eqOrNull('user_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.cloud_off_rounded, size: 48),
                const SizedBox(height: 12),
                const Text('Could not load verification status.'),
                const SizedBox(height: 12),
                FilledButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry')),
              ]),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: theme.primaryBackground,
            body:
                Center(child: CircularProgressIndicator(color: theme.primary)),
          );
        }

        final user = snapshot.data!.isEmpty ? null : snapshot.data!.first;
        final status = user?.verificationStatus?.trim().toLowerCase() ?? '';
        if (user?.isVerified == true ||
            status == 'verified' ||
            status == 'approved') {
          return const ApprovedWidget();
        }
        if (status == 'pending') return const PendingStatusWidget();

        final missing = _missingSections;
        final paymentConfirmed =
            user?.backgroundCheckPaymentStatus?.toLowerCase() == 'paid';
        final completed = (5 - missing.length) + (paymentConfirmed ? 1 : 0);
        return Scaffold(
          backgroundColor: theme.primaryBackground,
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => context.safePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: const Text('Secure Background Check'),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: _model.columnScrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.verified_user_rounded,
                              color: theme.primary),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Pay the one-time \$39.99 fee, then complete the secure identity and Police Clearance review.',
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(
                      child: Text('$completed of 6 steps complete',
                          style: theme.titleMedium
                              .copyWith(fontWeight: FontWeight.w700)),
                    ),
                    Text('${(completed / 6 * 100).round()}%'),
                  ]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completed / 6,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.primary.withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.payment_rounded,
                                    color: theme.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Background Check Payment',
                                        style: theme.titleMedium.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 3),
                                    Text(
                                      paymentConfirmed
                                          ? '\$39.99 payment confirmed'
                                          : 'Secure one-time payment through Stripe',
                                      style: theme.bodySmall.copyWith(
                                          color: paymentConfirmed
                                              ? Colors.green
                                              : theme.secondaryText),
                                    ),
                                  ],
                                ),
                              ),
                              if (paymentConfirmed)
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.green),
                            ],
                          ),
                          if (!paymentConfirmed) ...[
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: _openStripeCheckout,
                              icon: const Icon(Icons.lock_rounded, size: 18),
                              label: const Text('Pay \$39.99 with Stripe'),
                            ),
                            const SizedBox(height: 6),
                            TextButton.icon(
                              onPressed: () => setState(() {}),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('I paid — refresh status'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _VerificationStep(
                    icon: Icons.badge_outlined,
                    title: 'ID Verification',
                    subtitle: 'Upload a government-issued photo ID',
                    complete: FFAppState().stateIdUrl.trim().isNotEmpty,
                    onTap: () async {
                      await context.pushNamed(IDVerificationWidget.routeName);
                      if (mounted) setState(() {});
                    },
                  ),
                  _VerificationStep(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Identification',
                    subtitle: 'Add your legal name and date of birth',
                    complete: FFAppState().stateLegalName.trim().isNotEmpty &&
                        FFAppState().stateDOB.trim().isNotEmpty,
                    onTap: () async {
                      await context
                          .pushNamed(PersonalIdentificationWidget.routeName);
                      if (mounted) setState(() {});
                    },
                  ),
                  _VerificationStep(
                    icon: Icons.home_work_outlined,
                    title: 'Address History',
                    subtitle: 'Provide your current residential address',
                    complete: FFAppState().stateAddress.trim().isNotEmpty &&
                        FFAppState().stateCountry.trim().isNotEmpty &&
                        FFAppState().stateState.trim().isNotEmpty &&
                        FFAppState().stateZip.trim().isNotEmpty,
                    onTap: () async {
                      await context.pushNamed(AddressHistoryWidget.routeName);
                      if (mounted) setState(() {});
                    },
                  ),
                  _VerificationStep(
                    icon: Icons.face_retouching_natural_outlined,
                    title: 'Selfie Verification',
                    subtitle: 'Upload a clear photo for identity matching',
                    complete: FFAppState().stateSelfieUrl.trim().isNotEmpty,
                    onTap: () async {
                      await context
                          .pushNamed(AdditionalDetailsWidget.routeName);
                      if (mounted) setState(() {});
                    },
                  ),
                  _VerificationStep(
                    icon: Icons.description_outlined,
                    title: 'Police Clearance Certificate',
                    subtitle: _uploadingPoliceClearance
                        ? 'Uploading securely…'
                        : _policeClearanceFilename.isNotEmpty
                            ? _policeClearanceFilename
                            : paymentConfirmed
                                ? 'Upload PDF, JPG or PNG (maximum 10 MB)'
                                : 'Available after payment is confirmed',
                    complete: _policeClearancePath.trim().isNotEmpty,
                    onTap: () async {
                      if (!paymentConfirmed) {
                        showSnackbar(
                          context,
                          'Complete the \$39.99 Stripe payment first.',
                          backgroundColor: theme.error,
                        );
                        return;
                      }
                      await _pickAndUploadPoliceClearance();
                    },
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _consentAccepted,
                    onChanged: _submitting
                        ? null
                        : (value) =>
                            setState(() => _consentAccepted = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'I authorize Parents Partnership to review this information and certify that it is accurate.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _submitting ? null : () => _submit(user),
                    icon: _submitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                    label:
                        Text(_submitting ? 'Submitting…' : 'Submit for review'),
                  ),
                  if (missing.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('Still required: ${missing.join(', ')}',
                        textAlign: TextAlign.center,
                        style: theme.bodySmall
                            .copyWith(color: theme.secondaryText)),
                  ],
                  const SizedBox(height: 18),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.lock_rounded,
                        size: 14, color: theme.secondaryText),
                    const SizedBox(width: 5),
                    Text('Your data is encrypted and protected',
                        style: theme.bodySmall
                            .copyWith(color: theme.secondaryText)),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VerificationStep extends StatelessWidget {
  const _VerificationStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.complete,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool complete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.titleMedium
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style:
                          theme.bodySmall.copyWith(color: theme.secondaryText)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              complete
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: complete ? Colors.green : theme.secondaryText,
              size: complete ? 24 : 18,
            ),
          ]),
        ),
      ),
    );
  }
}
