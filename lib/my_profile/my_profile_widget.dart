import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'my_profile_model.dart';

export 'my_profile_model.dart';

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});
  static String routeName = 'MyProfile';
  static String routePath = '/myProfile';

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  late MyProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _profileRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyProfileModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _openEditProfile(UsersRow? user) async {
    final updated = await context.pushNamed(
      EditProfileWidget.routeName,
      queryParameters: {
        'profilepicture':
            serializeParam(user?.profilepicture, ParamType.String),
        'fullname': serializeParam(user?.fullName, ParamType.String),
        'country': serializeParam(user?.country, ParamType.String),
        'state': serializeParam(user?.state, ParamType.String),
        'age': serializeParam(user?.age, ParamType.String),
        'gender': serializeParam(user?.gender, ParamType.String),
        'bio': serializeParam(user?.bio, ParamType.String),
      }.withoutNulls,
    );
    if (updated == true && mounted) {
      safeSetState(() => _profileRefreshKey++);
    }
  }

  Future<void> _logOut() async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Log out?',
      message: 'You will need to sign in again to access your account.',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !mounted) return;
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    if (!mounted) return;
    GoRouter.of(context).clearRedirectLocation();
    context.goNamedAuth(SigninWidget.routeName, mounted);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsersRow>>(
      key: ValueKey(_profileRefreshKey),
      future: UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: AppErrorState(
              onRetry: () => safeSetState(() => _profileRefreshKey++),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: AppShimmerList());
        }

        final users = snapshot.data!;
        final user = users.isNotEmpty ? users.first : null;
        final rawName = user?.fullName?.trim() ?? '';
        final profileIncomplete = user == null ||
            rawName.isEmpty ||
            (user.country?.trim().isEmpty ?? true) ||
            (user.state?.trim().isEmpty ?? true) ||
            (user.age?.trim().isEmpty ?? true) ||
            (user.gender?.trim().isEmpty ?? true);
        final displayName = rawName.isEmpty ? 'Your Profile' : rawName;
        final theme = FlutterFlowTheme.of(context);

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          appBar: AppBar(
            backgroundColor: theme.primaryBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => context.pushNamed(HomeWidget.routeName),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: theme.primaryText, size: 20),
            ),
            title: Text('Profile',
                style: theme.titleLarge.copyWith(fontWeight: FontWeight.w700)),
            centerTitle: true,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: _model.columnController,
              padding: EdgeInsets.fromLTRB(
                MediaQuery.sizeOf(context).width < 360 ? 12 : 20,
                12,
                MediaQuery.sizeOf(context).width < 360 ? 12 : 20,
                32 + MediaQuery.viewPaddingOf(context).bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileHeader(
                        name: displayName,
                        email: currentUserEmail,
                        avatarUrl: user?.profilepicture,
                        isVerified: user?.isVerified ?? false,
                        onEdit: () => _openEditProfile(user),
                      ),
                      const SizedBox(height: 20),
                      _ProfileDetailsCard(user: user),
                      if (profileIncomplete) ...[
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            border: Border.all(color: theme.alternate),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Complete your profile',
                                  style: theme.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                'Add your details whenever you are ready.',
                                style: theme.bodyMedium
                                    .copyWith(color: theme.secondaryText),
                              ),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () => _openEditProfile(user),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Complete profile'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      Text('Explore',
                          style: theme.titleLarge
                              .copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 560
                              ? 3
                              : constraints.maxWidth < 270
                                  ? 1
                                  : 2;
                          return GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              mainAxisExtent: 118,
                            ),
                            children: [
                              _ProfileActionCard(
                                icon: Icons.settings_outlined,
                                label: 'Settings',
                                onTap: () =>
                                    context.pushNamed(SettingsWidget.routeName),
                              ),
                              _ProfileActionCard(
                                icon: Icons.handshake_outlined,
                                label: 'Partners',
                                onTap: () =>
                                    context.pushNamed(SpansarWidget.routeName),
                              ),
                              _ProfileActionCard(
                                icon: Icons.forum_outlined,
                                label: 'Forums',
                                onTap: () => context
                                    .pushNamed(FeedforumWidget.routeName),
                              ),
                              _ProfileActionCard(
                                icon: Icons.info_outline_rounded,
                                label: 'About',
                                onTap: () =>
                                    context.pushNamed(AboutWidget.routeName),
                              ),
                              _ProfileActionCard(
                                icon: Icons.public_rounded,
                                label: 'Follow us',
                                onTap: () => context.pushNamed(
                                    SocialMediaAccountsWidget.routeName),
                              ),
                              _ProfileActionCard(
                                icon: Icons.event_outlined,
                                label: 'Events',
                                onTap: () => launchURL(
                                    'https://parentspartnership.org/events/'),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: _logOut,
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text('Log out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.error,
                          minimumSize: const Size.fromHeight(52),
                          side: BorderSide(color: theme.error.withValues(alpha: .35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: theme.titleSmall
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isVerified,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String? avatarUrl;
  final bool isVerified;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.sizeOf(context).width < 360 ? 16 : 24,
        28,
        MediaQuery.sizeOf(context).width < 360 ? 16 : 24,
        24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primary, theme.primary.withValues(alpha: .78)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: .22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .14),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AppNetworkAvatar(
              url: avatarUrl,
              size: 96,
              semanticLabel: '$name profile photo',
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 7),
                  const Icon(Icons.verified_rounded,
                      color: Colors.white, size: 21),
                ],
              ],
            ),
          ),
          if (email.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium
                  .copyWith(color: Colors.white.withValues(alpha: .82)),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit profile'),
            style: FilledButton.styleFrom(
              foregroundColor: theme.primary,
              backgroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: theme.titleSmall.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.user});

  final UsersRow? user;

  String _valueOrDash(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? 'Not set' : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bio = user?.bio?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About you',
            style: theme.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          _ProfileDetailRow(
            icon: Icons.public_rounded,
            label: 'Country',
            value: _valueOrDash(user?.country),
          ),
          _ProfileDetailRow(
            icon: Icons.location_on_outlined,
            label: 'State',
            value: _valueOrDash(user?.state),
          ),
          _ProfileDetailRow(
            icon: Icons.cake_outlined,
            label: 'Age',
            value: _valueOrDash(user?.age),
          ),
          _ProfileDetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Gender',
            value: _valueOrDash(user?.gender),
          ),
          const SizedBox(height: 6),
          Text(
            'Bio',
            style: theme.labelLarge.copyWith(
              color: theme.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bio.isEmpty
                ? 'Add a short bio from Edit Profile so other parents can get to know you.'
                : bio,
            style: theme.bodyMedium.copyWith(
              color: bio.isEmpty ? theme.secondaryText : theme.primaryText,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.labelMedium.copyWith(
                    color: theme.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: theme.secondaryBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: theme.alternate),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.primary, size: 22),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: theme.bodyMedium
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
