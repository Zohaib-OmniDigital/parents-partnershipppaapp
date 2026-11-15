import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/keyboard_safe_form.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_detail_model.dart';
export 'add_detail_model.dart';

class AddDetailWidget extends StatefulWidget {
  const AddDetailWidget({super.key});

  static String routeName = 'AddDetail';
  static String routePath = '/addDetail';

  @override
  State<AddDetailWidget> createState() => _AddDetailWidgetState();
}

class _AddDetailWidgetState extends State<AddDetailWidget>
    with TickerProviderStateMixin {
  late AddDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  bool _isSaving = false;

  static const String _defaultProfilePic =
      'https://etdtsmjisbxyefwjcczw.supabase.co/storage/v1/object/public/chats/chats_profiles_pictures/1777693556786000.png';

  final List<String> _usStates = const [
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

  late final List<String> _ageList =
      List.generate(63, (index) => (18 + index).toString());

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddDetailModel());

    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.bioTextController ??= TextEditingController();
    _model.bioFocusNode ??= FocusNode();

    // Match the dropdown default so validation works if the user never opens it.
    _model.countryValue ??= 'United States';
    _model.countryValueController ??=
        FormFieldController<String>(_model.countryValue);

    animationsMap.addAll({
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutQuad,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 16.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: 'profile_picture',
      allowPhoto: true,
    );

    if (!mounted) return;

    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      safeSetState(() => _model.isDataUploading_uploadDataC19 = true);

      var selectedUploadedFiles = <FFUploadedFile>[];
      var downloadUrls = <String>[];

      try {
        if (mounted) {
          showUploadMessage(
            context,
            'Uploading profile picture...',
            showLoading: true,
          );
        }

        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                  originalFilename: m.originalFilename,
                ))
            .toList();

        // Update local preview immediately
        if (selectedUploadedFiles.isNotEmpty) {
          safeSetState(() {
            _model.uploadedLocalFile_uploadDataC19 =
                selectedUploadedFiles.first;
          });
        }

        downloadUrls = await uploadSupabaseStorageFiles(
          bucketName: 'profiles',
          selectedFiles: selectedMedia,
        );
      } finally {
        if (mounted) {
          hideSnackbar();
        }
        _model.isDataUploading_uploadDataC19 = false;
      }

      if (!mounted) return;

      if (selectedUploadedFiles.length == selectedMedia.length &&
          downloadUrls.length == selectedMedia.length) {
        safeSetState(() {
          _model.uploadedLocalFile_uploadDataC19 = selectedUploadedFiles.first;
          _model.uploadedFileUrl_uploadDataC19 = downloadUrls.first;
        });
        showUploadMessage(context, 'Profile picture updated!');
      } else {
        safeSetState(() {});
        showUploadMessage(context, 'Failed to upload photo. Please try again.');
      }
    }
  }

  Future<void> _handleContinue() async {
    if (_isSaving) return;

    // Validate form inputs
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    if (_model.countryValue == null || _model.countryValue!.trim().isEmpty) {
      _showWarningSnackBar('Please select your country.');
      return;
    }

    if (_model.stateValue == null || _model.stateValue!.trim().isEmpty) {
      _showWarningSnackBar('Please select your state.');
      return;
    }

    if (_model.ageValue == null || _model.ageValue!.trim().isEmpty) {
      _showWarningSnackBar('Please select your age.');
      return;
    }

    if (_model.gendeValue == null || _model.gendeValue!.trim().isEmpty) {
      _showWarningSnackBar('Please select your gender.');
      return;
    }

    safeSetState(() => _isSaving = true);

    try {
      final uid = currentUserUid.isNotEmpty
          ? currentUserUid
          : SupaFlow.client.auth.currentUser?.id;
      if (uid == null || uid.isEmpty) {
        _showWarningSnackBar('Please sign in before saving your profile.');
        return;
      }

      final photoToSave = _model.uploadedFileUrl_uploadDataC19.isNotEmpty
          ? _model.uploadedFileUrl_uploadDataC19
          : _defaultProfilePic;
      final fullName = _model.fullNameTextController.text.trim();

      await UsersTable().upsert({
        'country': _model.countryValue,
        'state': _model.stateValue,
        'age': _model.ageValue,
        'gender': _model.gendeValue,
        'bio': _model.bioTextController.text.trim(),
        'user_id': uid,
        'email': currentUserEmail,
        'full_name': fullName,
        'display_name': fullName,
        'name': fullName,
        'profilepicture': photoToSave,
        'photo_url': photoToSave,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      try {
        await SupaFlow.client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'name': fullName,
              'display_name': fullName,
              if (photoToSave.isNotEmpty) 'avatar_url': photoToSave,
              if (photoToSave.isNotEmpty) 'picture': photoToSave,
            },
          ),
        );
      } catch (authError) {
        debugPrint('Non-critical auth metadata update error: ');
      }

      if (mounted) {
        context.goNamed(HomeWidget.routeName);
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(
          context,
          'Failed to save profile: $e',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isSaving = false);
      }
    }
  }

  void _showWarningSnackBar(String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: FlutterFlowTheme.of(context).error,
    );
  }

  Widget _buildFieldLabel(String title,
      {String? subtitle, bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleMediumIsCustom,
                ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                  color: Color(0xFFEE2A7B), fontWeight: FontWeight.bold),
            ),
          if (subtitle != null) ...[
            const SizedBox(width: 6.0),
            Text(
              subtitle,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const borderColor = Color(0xFFE2E8F0);
    const inputBgColor = Color(0xFFF8FAFC);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: theme.primaryBackground,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(
              'Complete Profile',
              style: theme.titleMedium.override(
                fontFamily: theme.titleMediumFamily,
                fontSize: 18.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
                useGoogleFonts: !theme.titleMediumIsCustom,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                child: Center(
                  child: FlutterFlowIconButton(
                    borderColor: borderColor,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: inputBgColor,
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.primaryText,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(HomeWidget.routeName);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: true,
            child: KeyboardSafeScrollView(
              controller: _model.columnController,
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 36.0),
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step pill badge & intro text
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: theme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 14.0,
                                  color: theme.primary,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  'Profile Setup',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Tell Us About Yourself',
                            style: theme.displaySmall.override(
                              fontFamily: theme.displaySmallFamily,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryText,
                              useGoogleFonts: !theme.displaySmallIsCustom,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Provide your details to connect with other parents and discover local community activities.',
                            style: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              color: theme.secondaryText,
                              fontSize: 13.5,
                              letterSpacing: 0.0,
                              useGoogleFonts: !theme.bodyMediumIsCustom,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Profile Photo Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickAndUploadPhoto,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 110.0,
                                  height: 110.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: inputBgColor,
                                    border: Border.all(
                                      color:
                                          theme.primary.withValues(alpha: 0.3),
                                      width: 2.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 16.0,
                                        offset: Offset(0.0, 6.0),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: (_model
                                                .uploadedLocalFile_uploadDataC19
                                                .bytes
                                                ?.isNotEmpty ??
                                            false)
                                        ? Image.memory(
                                            _model
                                                .uploadedLocalFile_uploadDataC19
                                                .bytes!,
                                            width: 110.0,
                                            height: 110.0,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            _model.uploadedFileUrl_uploadDataC19
                                                    .isNotEmpty
                                                ? _model
                                                    .uploadedFileUrl_uploadDataC19
                                                : _defaultProfilePic,
                                            width: 110.0,
                                            height: 110.0,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.person_rounded,
                                              size: 60.0,
                                              color: theme.secondaryText,
                                            ),
                                          ),
                                  ),
                                ),

                                // Uploading indicator overlay
                                if (_model.isDataUploading_uploadDataC19)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.primary
                                            .withValues(alpha: 0.45),
                                      ),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 28.0,
                                          height: 28.0,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                // Camera action badge
                                Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    width: 34.0,
                                    height: 34.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.primary,
                                      border: Border.all(
                                        color: theme.primaryBackground,
                                        width: 2.5,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x28000000),
                                          blurRadius: 6.0,
                                          offset: Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: _pickAndUploadPhoto,
                            borderRadius: BorderRadius.circular(6.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                _model.uploadedFileUrl_uploadDataC19
                                            .isNotEmpty ||
                                        (_model.uploadedLocalFile_uploadDataC19
                                                .bytes?.isNotEmpty ??
                                            false)
                                    ? 'Change photo'
                                    : 'Add profile photo',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Full Name
                    _buildFieldLabel('Full Name'),
                    KeyboardSafeFormField(
                      focusNode: _model.fullNameFocusNode!,
                      child: TextFormField(
                      controller: _model.fullNameTextController,
                      focusNode: _model.fullNameFocusNode,
                      textCapitalization: TextCapitalization.words,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'e.g. Sarah Jenkins',
                        hintStyle: theme.labelMedium.override(
                          fontFamily: theme.labelMediumFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: !theme.labelMediumIsCustom,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: theme.secondaryText,
                          size: 20.0,
                        ),
                        filled: true,
                        fillColor: inputBgColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: borderColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.error,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      style: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        letterSpacing: 0.0,
                        color: theme.primaryText,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      cursorColor: theme.primary,
                      validator: _model.fullNameTextControllerValidator
                          .asValidator(context),
                      ),
                    ),

                    const SizedBox(height: 18.0),

                    // Country
                    _buildFieldLabel('Country'),
                    FlutterFlowDropDown<String>(
                      controller: _model.countryValueController ??=
                          FormFieldController<String>(
                              _model.countryValue ?? 'United States'),
                      options: const ['United States'],
                      onChanged: (val) =>
                          safeSetState(() => _model.countryValue = val),
                      width: double.infinity,
                      height: 50.0,
                      textStyle: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      hintText: 'Select country...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText,
                        size: 22.0,
                      ),
                      fillColor: inputBgColor,
                      elevation: 2.0,
                      borderColor: borderColor,
                      focusBorderColor: theme.primary,
                      borderWidth: 1.0,
                      borderRadius: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),

                    const SizedBox(height: 18.0),

                    // State
                    _buildFieldLabel('State', subtitle: '(USA)'),
                    FlutterFlowDropDown<String>(
                      controller: _model.stateValueController ??=
                          FormFieldController<String>(null),
                      options: _usStates,
                      onChanged: (val) =>
                          safeSetState(() => _model.stateValue = val),
                      width: double.infinity,
                      height: 50.0,
                      textStyle: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      hintText: 'Select state...',
                      searchHintText: 'Search state...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText,
                        size: 22.0,
                      ),
                      fillColor: inputBgColor,
                      elevation: 2.0,
                      borderColor: borderColor,
                      focusBorderColor: theme.primary,
                      borderWidth: 1.0,
                      borderRadius: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: true,
                      isMultiSelect: false,
                    ),

                    const SizedBox(height: 18.0),

                    // Age & Gender in a balanced 2-column row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age Dropdown
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Age'),
                              FlutterFlowDropDown<String>(
                                controller: _model.ageValueController ??=
                                    FormFieldController<String>(null),
                                options: _ageList,
                                onChanged: (val) =>
                                    safeSetState(() => _model.ageValue = val),
                                width: double.infinity,
                                height: 50.0,
                                textStyle: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.primaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !theme.bodyMediumIsCustom,
                                ),
                                hintText: 'Select age',
                                searchHintText: 'Search age...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: theme.secondaryText,
                                  size: 20.0,
                                ),
                                fillColor: inputBgColor,
                                elevation: 2.0,
                                borderColor: borderColor,
                                focusBorderColor: theme.primary,
                                borderWidth: 1.0,
                                borderRadius: 12.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                hidesUnderline: true,
                                isSearchable: true,
                                isMultiSelect: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 14.0),

                        // Gender Dropdown
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Gender'),
                              FlutterFlowDropDown<String>(
                                controller: _model.gendeValueController ??=
                                    FormFieldController<String>(null),
                                options: const ['Male', 'Female', 'Other'],
                                onChanged: (val) =>
                                    safeSetState(() => _model.gendeValue = val),
                                width: double.infinity,
                                height: 50.0,
                                textStyle: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.primaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !theme.bodyMediumIsCustom,
                                ),
                                hintText: 'Select...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: theme.secondaryText,
                                  size: 20.0,
                                ),
                                fillColor: inputBgColor,
                                elevation: 2.0,
                                borderColor: borderColor,
                                focusBorderColor: theme.primary,
                                borderWidth: 1.0,
                                borderRadius: 12.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18.0),

                    // Bio
                    _buildFieldLabel('About You (Bio)',
                        subtitle: 'Share your parenting journey or hobbies'),
                    KeyboardSafeFormField(
                      focusNode: _model.bioFocusNode!,
                      child: TextFormField(
                      controller: _model.bioTextController,
                      focusNode: _model.bioFocusNode,
                      autofocus: false,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'Passionate parent who loves exploring new parks, reading, and organizing fun activities for kids...',
                        hintStyle: theme.labelMedium.override(
                          fontFamily: theme.labelMediumFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontSize: 13.0,
                          useGoogleFonts: !theme.labelMediumIsCustom,
                        ),
                        filled: true,
                        fillColor: inputBgColor,
                        contentPadding: const EdgeInsets.all(16.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: borderColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.error,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      style: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        letterSpacing: 0.0,
                        color: theme.primaryText,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      cursorColor: theme.primary,
                      validator: _model.bioTextControllerValidator
                          .asValidator(context),
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    // Submit Button
                    FFButtonWidget(
                      onPressed: _isSaving ? null : _handleContinue,
                      text:
                          _isSaving ? 'Saving Profile...' : 'Complete Profile',
                      icon: _isSaving
                          ? null
                          : const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18.0,
                              color: Colors.white,
                            ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 52.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 8.0, 0.0),
                        color: theme.primary,
                        disabledColor: theme.primary.withValues(alpha: 0.6),
                        textStyle: theme.titleMedium.override(
                          fontFamily: theme.titleMediumFamily,
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: !theme.titleMediumIsCustom,
                        ),
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['buttonOnPageLoadAnimation']!),

                    Center(
                      child: TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => context.goNamed(HomeWidget.routeName),
                        child: const Text('Skip for now'),
                      ),
                    ),

                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
