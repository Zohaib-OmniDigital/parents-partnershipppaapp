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
import 'edit_profile_model.dart';

export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    super.key,
    this.profilepicture,
    this.fullname,
    this.country,
    this.state,
    this.age,
    this.gender,
    this.bio,
  });

  final String? profilepicture;
  final String? fullname;
  final String? country;
  final String? state;
  final String? age;
  final String? gender;
  final String? bio;

  static const String routeName = 'EditProfile';
  static const String routePath = '/EditProfile';

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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

  static final List<String> _ageList =
      List.generate(63, (index) => (18 + index).toString());

  static const List<String> _genderList = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _model.textFieldTextController ??=
        TextEditingController(text: widget.fullname ?? '');
    _model.textFieldFocusNode ??= FocusNode();

    _model.bioTextController ??=
        TextEditingController(text: widget.bio ?? '');
    _model.bioFocusNode ??= FocusNode();

    // Sanitize and set country
    final initialCountry = (widget.country?.trim().isNotEmpty ?? false)
        ? widget.country!.trim()
        : 'United States';
    _model.countryValue = initialCountry;
    _model.countryValueController =
        FormFieldController<String>(_model.countryValue);

    // Sanitize and set state
    final sanitizedState = widget.state?.trim();
    if (sanitizedState != null && _usStates.contains(sanitizedState)) {
      _model.stateValue = sanitizedState;
    }
    _model.stateValueController =
        FormFieldController<String>(_model.stateValue);

    // Sanitize and set age
    final sanitizedAge = widget.age?.trim();
    if (sanitizedAge != null && _ageList.contains(sanitizedAge)) {
      _model.ageValue = sanitizedAge;
    }
    _model.ageValueController =
        FormFieldController<String>(_model.ageValue);

    // Sanitize and set gender
    final sanitizedGender = widget.gender?.trim();
    if (sanitizedGender != null && _genderList.contains(sanitizedGender)) {
      _model.gendeValue = sanitizedGender;
    }
    _model.gendeValueController =
        FormFieldController<String>(_model.gendeValue);

    _model.uploadedFileUrl_uploadDataZii = widget.profilepicture?.trim() ?? '';

    // If initial data is missing, query the user's row from the database to prefill
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final uid = currentUserUid.isNotEmpty
          ? currentUserUid
          : SupaFlow.client.auth.currentUser?.id;

      if (uid != null && uid.isNotEmpty) {
        try {
          final rows = await UsersTable().querySingleRow(
            queryFn: (q) => q.eqOrNull('user_id', uid),
          );
          if (!mounted || rows.isEmpty) return;

          final row = rows.first;
          bool stateChanged = false;

          if (_model.textFieldTextController!.text.trim().isEmpty &&
              (row.fullName?.trim().isNotEmpty ?? false)) {
            _model.textFieldTextController!.text = row.fullName!.trim();
            stateChanged = true;
          }

          if (_model.bioTextController!.text.trim().isEmpty &&
              (row.bio?.trim().isNotEmpty ?? false)) {
            _model.bioTextController!.text = row.bio!.trim();
            stateChanged = true;
          }

          if (_model.uploadedFileUrl_uploadDataZii.isEmpty &&
              !_imageRemoved &&
              (row.profilepicture?.trim().isNotEmpty ?? false)) {
            _model.uploadedFileUrl_uploadDataZii = row.profilepicture!.trim();
            stateChanged = true;
          }

          if (_model.stateValue == null &&
              row.state != null &&
              _usStates.contains(row.state!.trim())) {
            _model.stateValue = row.state!.trim();
            _model.stateValueController?.value = _model.stateValue;
            stateChanged = true;
          }

          if (_model.ageValue == null &&
              row.age != null &&
              _ageList.contains(row.age!.trim())) {
            _model.ageValue = row.age!.trim();
            _model.ageValueController?.value = _model.ageValue;
            stateChanged = true;
          }

          if (_model.gendeValue == null &&
              row.gender != null &&
              _genderList.contains(row.gender!.trim())) {
            _model.gendeValue = row.gender!.trim();
            _model.gendeValueController?.value = _model.gendeValue;
            stateChanged = true;
          }

          if (stateChanged && mounted) {
            safeSetState(() {});
          }
        } catch (e) {
          debugPrint('Error loading profile from database: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_model.isDataUploading_uploadDataZii || _isSaving) return;

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

      safeSetState(() => _model.isDataUploading_uploadDataZii = true);

      final selectedFile = selectedMedia.first;
      final uploadedLocal = FFUploadedFile(
        name: selectedFile.storagePath.split('/').last,
        bytes: selectedFile.bytes,
        height: selectedFile.dimensions?.height,
        width: selectedFile.dimensions?.width,
        blurHash: selectedFile.blurHash,
        originalFilename: selectedFile.originalFilename,
      );

      safeSetState(() {
        _imageRemoved = false;
        _model.uploadedLocalFile_uploadDataZii = uploadedLocal;
      });

      final downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'profiles',
        selectedFiles: selectedMedia,
      );

      if (!mounted) return;

      if (downloadUrls.isNotEmpty) {
        safeSetState(() {
          _model.uploadedFileUrl_uploadDataZii = downloadUrls.first;
        });
        showSnackbar(context, 'Photo uploaded successfully.');
      } else {
        showSnackbar(
          context,
          'Failed to upload image. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } catch (e) {
      debugPrint('Error picking/uploading photo in EditProfile: $e');
      if (mounted) {
        showSnackbar(
          context,
          'An error occurred while uploading. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _model.isDataUploading_uploadDataZii = false);
      }
    }
  }

  void _removePhoto() {
    if (_model.isDataUploading_uploadDataZii || _isSaving) return;
    safeSetState(() {
      _imageRemoved = true;
      _model.uploadedLocalFile_uploadDataZii =
          FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
      _model.uploadedFileUrl_uploadDataZii = '';
    });
  }

  Future<void> _saveProfile() async {
    if (_isSaving || _model.isDataUploading_uploadDataZii) return;

    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    final fullName = _model.textFieldTextController?.text.trim() ?? '';
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
        'Please sign in to update your profile.',
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }

    safeSetState(() => _isSaving = true);

    try {
      String finalPhotoUrl = _model.uploadedFileUrl_uploadDataZii.trim();

      // If a local image was picked and upload wasn't finished, upload now
      if (finalPhotoUrl.isEmpty &&
          !_imageRemoved &&
          _model.uploadedLocalFile_uploadDataZii.bytes != null &&
          _model.uploadedLocalFile_uploadDataZii.bytes!.isNotEmpty) {
        final selectedMedia = [
          SelectedFile(
            storagePath:
                'profile_picture/${DateTime.now().microsecondsSinceEpoch}.jpg',
            bytes: _model.uploadedLocalFile_uploadDataZii.bytes!,
            originalFilename: _model
                    .uploadedLocalFile_uploadDataZii.originalFilename.isNotEmpty
                ? _model.uploadedLocalFile_uploadDataZii.originalFilename
                : 'profile.jpg',
          ),
        ];

        final urls = await uploadSupabaseStorageFiles(
          bucketName: 'profiles',
          selectedFiles: selectedMedia,
        );
        if (urls.isNotEmpty) {
          finalPhotoUrl = urls.first;
          _model.uploadedFileUrl_uploadDataZii = finalPhotoUrl;
        }
      }

      final country = _model.countryValue ?? widget.country ?? 'United States';
      final state = _model.stateValue ?? widget.state ?? '';
      final age = _model.ageValue ?? widget.age ?? '';
      final gender = _model.gendeValue ?? widget.gender ?? '';
      final bio = _model.bioTextController?.text.trim() ?? '';

      final userData = <String, dynamic>{
        'user_id': uid,
        'full_name': fullName,
        'display_name': fullName,
        'name': fullName,
        'country': country,
        'state': state,
        'age': age,
        'gender': gender,
        'bio': bio,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_imageRemoved) {
        userData['profilepicture'] = '';
        userData['photo_url'] = '';
      } else if (finalPhotoUrl.isNotEmpty) {
        userData['profilepicture'] = finalPhotoUrl;
        userData['photo_url'] = finalPhotoUrl;
      } else if (widget.profilepicture != null &&
          widget.profilepicture!.trim().isNotEmpty) {
        userData['profilepicture'] = widget.profilepicture!.trim();
        userData['photo_url'] = widget.profilepicture!.trim();
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
              if (userData['profilepicture'] != null &&
                  userData['profilepicture'].toString().isNotEmpty)
                'avatar_url': userData['profilepicture'],
              if (userData['profilepicture'] != null &&
                  userData['profilepicture'].toString().isNotEmpty)
                'picture': userData['profilepicture'],
            },
          ),
        );
      } catch (authError) {
        debugPrint('Auth metadata sync notice: $authError');
      }

      if (!mounted) return;

      showSnackbar(context, 'Profile updated successfully.');
      if (context.canPop()) {
        context.pop();
      } else {
        context.goNamed(MyProfileWidget.routeName);
      }
    } catch (error) {
      debugPrint('Edit profile save error: $error');
      if (mounted) {
        showSnackbar(
          context,
          'Could not save your profile. Your changes are still here; please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isSaving = false);
      }
    }
  }

  Widget _buildAvatarPreview(FlutterFlowTheme theme) {
    final hasLocalBytes =
        _model.uploadedLocalFile_uploadDataZii.bytes != null &&
            _model.uploadedLocalFile_uploadDataZii.bytes!.isNotEmpty;
    final currentUrl = _model.uploadedFileUrl_uploadDataZii.trim().isNotEmpty
        ? _model.uploadedFileUrl_uploadDataZii.trim()
        : (!_imageRemoved && widget.profilepicture != null
            ? widget.profilepicture!.trim()
            : '');

    if (_model.isDataUploading_uploadDataZii) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (hasLocalBytes)
            Image.memory(
              _model.uploadedLocalFile_uploadDataZii.bytes!,
              width: 124,
              height: 124,
              fit: BoxFit.cover,
            )
          else if (currentUrl.isNotEmpty)
            AppNetworkAvatar(url: currentUrl, size: 124)
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
        _model.uploadedLocalFile_uploadDataZii.bytes!,
        width: 124,
        height: 124,
        fit: BoxFit.cover,
      );
    }

    if (!_imageRemoved && currentUrl.isNotEmpty) {
      return AppNetworkAvatar(
        url: currentUrl,
        size: 124,
        semanticLabel: 'Profile photo',
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

  void _handleBackNavigation() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(MyProfileWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasPhoto = !_imageRemoved &&
        ((_model.uploadedLocalFile_uploadDataZii.bytes != null &&
                _model.uploadedLocalFile_uploadDataZii.bytes!.isNotEmpty) ||
            _model.uploadedFileUrl_uploadDataZii.trim().isNotEmpty ||
            (widget.profilepicture != null &&
                widget.profilepicture!.trim().isNotEmpty));

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
            leading: IconButton(
              tooltip: 'Back',
              onPressed: _handleBackNavigation,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.primaryText,
                size: 20,
              ),
            ),
            title: Text(
              'Edit Profile',
              style: theme.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: KeyboardSafeScrollView(
              controller: _model.columnController,
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 36.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Container(
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
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Avatar Preview & Actions
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _model.isDataUploading_uploadDataZii
                                      ? null
                                      : _pickPhoto,
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
                                      onTap: _model.isDataUploading_uploadDataZii
                                          ? null
                                          : _pickPhoto,
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
                          const SizedBox(height: 12),

                          // Photo Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (hasPhoto) ...[
                                TextButton.icon(
                                  onPressed:
                                      _model.isDataUploading_uploadDataZii ||
                                              _isSaving
                                          ? null
                                          : _pickPhoto,
                                  icon: const Icon(Icons.edit_rounded, size: 17),
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
                                      _model.isDataUploading_uploadDataZii ||
                                              _isSaving
                                          ? null
                                          : _removePhoto,
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
                                      _model.isDataUploading_uploadDataZii ||
                                              _isSaving
                                          ? null
                                          : _pickPhoto,
                                  icon: const Icon(Icons.add_a_photo_outlined,
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

                          // Full Name
                          Text(
                            'Full Name',
                            style: theme.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          KeyboardSafeFormField(
                            focusNode: _model.textFieldFocusNode!,
                            child: TextFormField(
                              controller: _model.textFieldTextController,
                              focusNode: _model.textFieldFocusNode,
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
                              decoration: _inputDecoration(
                                theme,
                                hintText: 'Enter your full name',
                                prefixIcon: Icons.person_outline_rounded,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Country
                          Text(
                            'Country',
                            style: theme.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FlutterFlowDropDown<String>(
                            controller: _model.countryValueController ??=
                                FormFieldController<String>(
                              _model.countryValue ?? 'United States',
                            ),
                            options: const ['United States'],
                            onChanged: (val) =>
                                safeSetState(() => _model.countryValue = val),
                            width: double.infinity,
                            height: 52.0,
                            textStyle: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !theme.bodyMediumIsCustom,
                            ),
                            hintText: 'Select country...',
                            fillColor: const Color(0xFFF9FAFC),
                            elevation: 2.0,
                            borderColor: const Color(0xFFD6DFEC),
                            borderWidth: 1.0,
                            borderRadius: 12.0,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            hidesUnderline: true,
                          ),
                          const SizedBox(height: 20),

                          // State
                          Row(
                            children: [
                              Text(
                                'State',
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
                            onChanged: (val) =>
                                safeSetState(() => _model.stateValue = val),
                            width: double.infinity,
                            height: 52.0,
                            textStyle: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !theme.bodyMediumIsCustom,
                            ),
                            hintText: 'Select state...',
                            searchHintText: 'Search state...',
                            fillColor: const Color(0xFFF9FAFC),
                            elevation: 2.0,
                            borderColor: const Color(0xFFD6DFEC),
                            borderWidth: 1.0,
                            borderRadius: 12.0,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            hidesUnderline: true,
                            isSearchable: true,
                          ),
                          const SizedBox(height: 20),

                          // Age & Gender Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Age
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Age',
                                      style: theme.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FlutterFlowDropDown<String>(
                                      controller: _model.ageValueController ??=
                                          FormFieldController<String>(
                                        _model.ageValue,
                                      ),
                                      options: _ageList,
                                      onChanged: (val) => safeSetState(
                                          () => _model.ageValue = val),
                                      width: double.infinity,
                                      height: 52.0,
                                      textStyle: theme.bodyMedium.override(
                                        fontFamily: theme.bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !theme.bodyMediumIsCustom,
                                      ),
                                      hintText: 'Select age',
                                      searchHintText: 'Search age...',
                                      fillColor: const Color(0xFFF9FAFC),
                                      elevation: 2.0,
                                      borderColor: const Color(0xFFD6DFEC),
                                      borderWidth: 1.0,
                                      borderRadius: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      hidesUnderline: true,
                                      isSearchable: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Gender
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gender',
                                      style: theme.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FlutterFlowDropDown<String>(
                                      controller:
                                          _model.gendeValueController ??=
                                              FormFieldController<String>(
                                        _model.gendeValue,
                                      ),
                                      options: _genderList,
                                      onChanged: (val) => safeSetState(
                                          () => _model.gendeValue = val),
                                      width: double.infinity,
                                      height: 52.0,
                                      textStyle: theme.bodyMedium.override(
                                        fontFamily: theme.bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !theme.bodyMediumIsCustom,
                                      ),
                                      hintText: 'Select gender',
                                      fillColor: const Color(0xFFF9FAFC),
                                      elevation: 2.0,
                                      borderColor: const Color(0xFFD6DFEC),
                                      borderWidth: 1.0,
                                      borderRadius: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      hidesUnderline: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Bio
                          Text(
                            'About You (Bio)',
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
                              maxLines: 4,
                              minLines: 3,
                              textInputAction: TextInputAction.done,
                              decoration: _inputDecoration(
                                theme,
                                hintText:
                                    'Tell other parents a little about yourself, your kids, and what brings you to Parents Partnership...',
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Save Button
                          FFButtonWidget(
                            onPressed: _isSaving ? null : _saveProfile,
                            text: _isSaving ? 'Saving changes...' : 'Save Changes',
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    FlutterFlowTheme theme, {
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.bodyMedium.copyWith(
        color: theme.secondaryText,
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
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
    );
  }
}
