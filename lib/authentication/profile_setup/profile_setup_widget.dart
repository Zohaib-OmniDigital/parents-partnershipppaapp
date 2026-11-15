import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/components/keyboard_safe_form.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'profile_setup_model.dart';

export 'profile_setup_model.dart';

class ProfileSetupWidget extends StatefulWidget {
  const ProfileSetupWidget({super.key});

  static const String routeName = 'ProfileSetup';
  static const String routePath = '/profileSetup';

  @override
  State<ProfileSetupWidget> createState() => _ProfileSetupWidgetState();
}

class _ProfileSetupWidgetState extends State<ProfileSetupWidget> {
  late ProfileSetupModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;
  bool _imageRemoved = false;

  static const List<String> _usStates = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'District of Columbia',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileSetupModel());
    _model.nameTextController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();

    _model.bioTextController ??= TextEditingController();
    _model.bioFocusNode ??= FocusNode();

    _model.stateValueController ??=
        FormFieldController<String>(_model.stateValue);

    // Automatically prefill name and photo from authentication or existing record
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 1. Check current auth metadata
      final authName = currentUserDisplayName.trim();
      final meta = SupaFlow.client.auth.currentUser?.userMetadata;
      final metaName = (meta?['full_name'] as String? ??
              meta?['name'] as String? ??
              meta?['display_name'] as String?)
          ?.trim() ??
          '';

      if (_model.nameTextController!.text.trim().isEmpty) {
        if (authName.isNotEmpty) {
          _model.nameTextController!.text = authName;
        } else if (metaName.isNotEmpty) {
          _model.nameTextController!.text = metaName;
        }
      }

      final authPhoto = currentUserPhoto.trim();
      final metaPhoto = (meta?['avatar_url'] as String? ??
              meta?['picture'] as String?)
          ?.trim() ??
          '';

      if (_model.uploadedFileUrl.isEmpty && !_imageRemoved) {
        if (authPhoto.isNotEmpty) {
          _model.uploadedFileUrl = authPhoto;
        } else if (metaPhoto.isNotEmpty) {
          _model.uploadedFileUrl = metaPhoto;
        }
      }

      // 2. Query UsersTable to see if a record already exists with name/picture
      final uid = currentUserUid.isNotEmpty
          ? currentUserUid
          : SupaFlow.client.auth.currentUser?.id;

      if (uid != null && uid.isNotEmpty) {
        try {
          final rows = await UsersTable().querySingleRow(
            queryFn: (q) => q.eqOrNull('user_id', uid),
          );
          if (!mounted) return;
          if (rows.isNotEmpty) {
            final row = rows.first;
            if (_model.nameTextController!.text.trim().isEmpty &&
                (row.fullName?.trim().isNotEmpty ?? false)) {
              _model.nameTextController!.text = row.fullName!.trim();
            }
            if (_model.uploadedFileUrl.isEmpty &&
                !_imageRemoved &&
                (row.profilepicture?.trim().isNotEmpty ?? false)) {
              _model.uploadedFileUrl = row.profilepicture!.trim();
            }
            if (_model.stateValue == null &&
                row.state != null &&
                _usStates.contains(row.state!.trim())) {
              _model.stateValue = row.state!.trim();
              _model.stateValueController?.value = _model.stateValue;
            }
            if (_model.bioTextController!.text.trim().isEmpty &&
                (row.bio?.trim().isNotEmpty ?? false)) {
              _model.bioTextController!.text = row.bio!.trim();
            }
          }
        } catch (e) {
          debugPrint('Error fetching existing user row: $e');
        }
      }

      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_model.isDataUploading || _isSaving) return;

    try {
      final selectedMedia = await selectMediaWithSourceBottomSheet(
        context: context,
        storageFolderPath: 'profile_picture',
        allowPhoto: true,
      );

      if (!mounted || selectedMedia == null || selectedMedia.isEmpty) return;

      if (!selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
        return;
      }

      safeSetState(() => _model.isDataUploading = true);

      final selectedFile = selectedMedia.first;
      final uploadedLocal = FFUploadedFile(
        name: selectedFile.storagePath.split('/').last,
        bytes: selectedFile.bytes,
        height: selectedFile.dimensions?.height,
        width: selectedFile.dimensions?.width,
        blurHash: selectedFile.blurHash,
        originalFilename: selectedFile.originalFilename,
      );

      // Immediately show local preview
      safeSetState(() {
        _imageRemoved = false;
        _model.uploadedLocalFile = uploadedLocal;
      });

      // Upload binary to Supabase 'profiles' bucket
      final downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'profiles',
        selectedFiles: selectedMedia,
      );

      if (!mounted) return;

      if (downloadUrls.isNotEmpty) {
        safeSetState(() {
          _model.uploadedFileUrl = downloadUrls.first;
        });
        showSnackbar(context, 'Profile picture uploaded successfully!');
      } else {
        showSnackbar(
          context,
          'Failed to upload image. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } catch (e) {
      debugPrint('Error picking/uploading photo: $e');
      if (mounted) {
        showSnackbar(
          context,
          'An error occurred while uploading. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _model.isDataUploading = false);
      }
    }
  }

  void _removeImage() {
    if (_model.isDataUploading || _isSaving) return;
    safeSetState(() {
      _imageRemoved = true;
      _model.uploadedLocalFile =
          FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
      _model.uploadedFileUrl = '';
    });
  }

  Future<void> _saveProfile() async {
    if (_isSaving || _model.isDataUploading) return;

    // Validate name input
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    final fullName = _model.nameTextController?.text.trim() ?? '';
    if (fullName.isEmpty) {
      showSnackbar(
        context,
        'Please enter your full name.',
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }

    final uid = currentUserUid.isNotEmpty
        ? currentUserUid
        : SupaFlow.client.auth.currentUser?.id;

    if (uid == null || uid.isEmpty) {
      showSnackbar(
        context,
        'Please wait a moment while your session connects, then try again.',
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }

    safeSetState(() => _isSaving = true);

    try {
      String finalPhotoUrl = _model.uploadedFileUrl.trim();

      // If local file was selected but upload hadn't completed, upload now
      if (finalPhotoUrl.isEmpty &&
          !_imageRemoved &&
          _model.uploadedLocalFile.bytes != null &&
          _model.uploadedLocalFile.bytes!.isNotEmpty) {
        final selectedMedia = [
          SelectedFile(
            storagePath:
                'profile_picture/${DateTime.now().microsecondsSinceEpoch}.jpg',
            bytes: _model.uploadedLocalFile.bytes!,
            originalFilename:
                _model.uploadedLocalFile.originalFilename.isNotEmpty
                    ? _model.uploadedLocalFile.originalFilename
                    : 'profile.jpg',
          ),
        ];

        final urls = await uploadSupabaseStorageFiles(
          bucketName: 'profiles',
          selectedFiles: selectedMedia,
        );
        if (urls.isNotEmpty) {
          finalPhotoUrl = urls.first;
          _model.uploadedFileUrl = finalPhotoUrl;
        }
      }

      final state = _model.stateValue ?? '';
      final bio = _model.bioTextController?.text.trim() ?? '';

      // Upsert into Supabase database 'users' table
      final userData = <String, dynamic>{
        'user_id': uid,
        'full_name': fullName,
        'display_name': fullName,
        'name': fullName,
        'country': 'United States',
        if (state.isNotEmpty) 'state': state,
        if (bio.isNotEmpty) 'bio': bio,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_imageRemoved) {
        userData['profilepicture'] = '';
        userData['photo_url'] = '';
      } else if (finalPhotoUrl.isNotEmpty) {
        userData['profilepicture'] = finalPhotoUrl;
        userData['photo_url'] = finalPhotoUrl;
      }

      if (currentUserEmail.isNotEmpty) {
        userData['email'] = currentUserEmail;
      } else if (SupaFlow.client.auth.currentUser?.email != null) {
        userData['email'] = SupaFlow.client.auth.currentUser!.email!;
      }

      await UsersTable().upsert(userData, onConflict: 'user_id');

      // Synchronize Supabase Auth user metadata
      try {
        await SupaFlow.client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'name': fullName,
              'display_name': fullName,
              if (finalPhotoUrl.isNotEmpty) 'avatar_url': finalPhotoUrl,
              if (finalPhotoUrl.isNotEmpty) 'picture': finalPhotoUrl,
            },
          ),
        );
      } catch (authError) {
        debugPrint('Non-critical auth metadata update error: $authError');
      }

      if (!mounted) return;

      showSnackbar(context, 'Profile set up successfully!');
      context.goNamed(HomeWidget.routeName);
    } catch (error) {
      debugPrint('Error saving profile: $error');
      if (mounted) {
        showSnackbar(
          context,
          'Could not save your profile. Your inputs are still here; please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isSaving = false);
      }
    }
  }

  void _skipForNow() {
    if (_isSaving) return;
    context.goNamed(HomeWidget.routeName);
  }

  Widget _buildAvatarPreview(FlutterFlowTheme theme) {
    final hasLocalBytes = _model.uploadedLocalFile.bytes != null &&
        _model.uploadedLocalFile.bytes!.isNotEmpty;
    final hasRemoteUrl =
        !_imageRemoved && _model.uploadedFileUrl.trim().isNotEmpty;

    if (_model.isDataUploading) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (hasLocalBytes)
            Image.memory(
              _model.uploadedLocalFile.bytes!,
              width: 124,
              height: 124,
              fit: BoxFit.cover,
            )
          else if (hasRemoteUrl)
            AppNetworkAvatar(url: _model.uploadedFileUrl, size: 124)
          else
            Container(color: theme.primary.withValues(alpha: 0.1)),
          Container(
            color: Colors.black45,
            child: const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (!_imageRemoved && hasLocalBytes) {
      return Image.memory(
        _model.uploadedLocalFile.bytes!,
        width: 124,
        height: 124,
        fit: BoxFit.cover,
      );
    }

    if (hasRemoteUrl) {
      return AppNetworkAvatar(
        url: _model.uploadedFileUrl,
        size: 124,
        semanticLabel: 'Profile picture preview',
      );
    }

    return ColoredBox(
      color: theme.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: theme.primary.withValues(alpha: 0.75),
          size: 64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImage = !_imageRemoved &&
        ((_model.uploadedLocalFile.bytes != null &&
                _model.uploadedLocalFile.bytes!.isNotEmpty) ||
            _model.uploadedFileUrl.trim().isNotEmpty);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF7F8FC),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: context.canPop()
                ? IconButton(
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: theme.primaryText,
                      size: 20,
                    ),
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: _isSaving ? null : _skipForNow,
                  child: Text(
                    'Skip',
                    style: theme.labelLarge.copyWith(
                      color: theme.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: KeyboardSafeScrollView(
              controller: _model.scrollController,
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 32.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Text(
                        'Set Up Your Profile',
                        textAlign: TextAlign.center,
                        style: theme.headlineMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your name and a photo so other parents can recognize and connect with you.',
                        textAlign: TextAlign.center,
                        style: theme.bodyMedium.copyWith(
                          color: theme.secondaryText,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Card Container
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: const Color(0xFFE5E9F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _model.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Profile Picture Preview & Controls
                              Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: _model.isDataUploading
                                          ? null
                                          : _pickImage,
                                      child: Container(
                                        width: 124,
                                        height: 124,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.primaryBackground,
                                          border: Border.all(
                                            color: theme.primary,
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.primary
                                                  .withValues(alpha: 0.16),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: _buildAvatarPreview(theme),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Material(
                                        color: theme.primary,
                                        shape: const CircleBorder(),
                                        elevation: 3,
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: _model.isDataUploading
                                              ? null
                                              : _pickImage,
                                          child: const Padding(
                                            padding: EdgeInsets.all(9),
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Picture Action Buttons (Change / Remove / Add)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (hasImage) ...[
                                    TextButton.icon(
                                      onPressed:
                                          _model.isDataUploading || _isSaving
                                              ? null
                                              : _pickImage,
                                      icon: const Icon(Icons.edit_rounded,
                                          size: 17),
                                      label: const Text('Change photo'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: theme.primary,
                                        textStyle: theme.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed:
                                          _model.isDataUploading || _isSaving
                                              ? null
                                              : _removeImage,
                                      icon: Icon(Icons.delete_outline_rounded,
                                          size: 17, color: theme.error),
                                      label: Text(
                                        'Remove',
                                        style: TextStyle(color: theme.error),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: theme.error,
                                        textStyle: theme.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    TextButton.icon(
                                      onPressed:
                                          _model.isDataUploading || _isSaving
                                              ? null
                                              : _pickImage,
                                      icon: const Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 18),
                                      label: const Text('Upload photo'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: theme.primary,
                                        textStyle: theme.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Full Name Field (Required)
                              Text(
                                'Full Name *',
                                style: theme.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              KeyboardSafeFormField(
                                focusNode: _model.nameFocusNode!,
                                child: TextFormField(
                                  controller: _model.nameTextController,
                                  focusNode: _model.nameFocusNode,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) {
                                      return 'Please enter your full name.';
                                    }
                                    if (text.length < 2) {
                                      return 'Name must be at least 2 characters.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Sarah Jenkins',
                                    hintStyle: theme.bodyMedium.copyWith(
                                      color: theme.secondaryText,
                                    ),
                                    prefixIcon: const Icon(
                                        Icons.person_outline_rounded),
                                    suffixIcon: _model.nameTextController?.text
                                                .isNotEmpty ==
                                            true
                                        ? IconButton(
                                            tooltip: 'Clear',
                                            icon: const Icon(
                                                Icons.clear_rounded,
                                                size: 20),
                                            onPressed: () {
                                              _model.nameTextController
                                                  ?.clear();
                                              safeSetState(() {});
                                            },
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 16.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DFEC),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DFEC),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        color: theme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        color: theme.error,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        color: theme.error,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // State Selection (Optional)
                              Row(
                                children: [
                                  Text(
                                    'State (Optional)',
                                    style: theme.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(USA)',
                                    style: theme.bodySmall.copyWith(
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              FlutterFlowDropDown<String>(
                                controller: _model.stateValueController ??=
                                    FormFieldController<String>(
                                  _model.stateValue,
                                ),
                                options: _usStates,
                                onChanged: (val) => safeSetState(
                                    () => _model.stateValue = val),
                                width: double.infinity,
                                height: 52.0,
                                textStyle: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !theme.bodyMediumIsCustom,
                                ),
                                hintText: 'Select your state...',
                                searchHintText: 'Search state...',
                                fillColor: const Color(0xFFF9FAFC),
                                elevation: 2.0,
                                borderColor: const Color(0xFFD6DFEC),
                                borderWidth: 1.0,
                                borderRadius: 12.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                hidesUnderline: true,
                                isSearchable: true,
                              ),
                              const SizedBox(height: 20),

                              // Bio (Optional)
                              Text(
                                'About You (Optional)',
                                style: theme.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              KeyboardSafeFormField(
                                focusNode: _model.bioFocusNode!,
                                child: TextFormField(
                                  controller: _model.bioTextController,
                                  focusNode: _model.bioFocusNode,
                                  maxLines: 3,
                                  minLines: 2,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _saveProfile(),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Share a sentence about your family, kids, or hobbies...',
                                    hintStyle: theme.bodyMedium.copyWith(
                                      color: theme.secondaryText,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 14.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DFEC),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DFEC),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        color: theme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Save / Continue Button
                              FFButtonWidget(
                                onPressed: _isSaving ? null : _saveProfile,
                                text:
                                    _isSaving ? 'Saving profile...' : 'Continue',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 52.0,
                                  color: theme.primary,
                                  textStyle: theme.titleSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  disabledColor:
                                      theme.primary.withValues(alpha: 0.5),
                                  disabledTextColor: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Skip for now link
                      Center(
                        child: TextButton(
                          onPressed: _isSaving ? null : _skipForNow,
                          child: Text(
                            'Skip for now',
                            style: theme.bodyMedium.copyWith(
                              color: theme.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }
}
