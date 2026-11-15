import '/components/menucomponent_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'home_model.dart';

export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _openMenuSheet() async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      context: context,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const MenucomponentWidget(),
        ),
      ),
    );
  }

  Future<void> _openDonationImage() async {
    await Navigator.push(
      context,
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => FlutterFlowExpandedImageView(
          image: Image.asset(
            'assets/images/aaaasxx.png',
            fit: BoxFit.contain,
          ),
          allowRotation: false,
          tag: 'homeDonationImage',
          useHeroAnimation: true,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> _openDonationPage() async {
    try {
      await launchURL('https://parentspartnership.org/donate/');
    } catch (_) {
      if (mounted) {
        showSnackbar(
          context,
          'Could not open the donation page. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
              tooltip: 'Open menu',
              onPressed: () => context.pushNamed(MenuWidget.routeName),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          title: Image.asset(
            'assets/images/PP_App-removebg-preview.png',
            height: 44,
            fit: BoxFit.contain,
            semanticLabel: 'Parents Partnership',
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => context.pushNamed(NotificationsWidget.routeName),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
              controller: _model.columnController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                viewport.maxWidth < 600 ? 16 : 24,
                22,
                viewport.maxWidth < 600 ? 16 : 24,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'WELCOME TO THE VILLAGE',
                        textAlign: TextAlign.center,
                        style: theme.titleMedium.copyWith(
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/PP_App-removebg-preview.png',
                        height: 92,
                        fit: BoxFit.contain,
                        semanticLabel: 'Parents Partnership',
                      ),
                      const SizedBox(height: 22),
                      Semantics(
                        button: true,
                        label: 'Search and explore the menu',
                        child: InkWell(
                          onTap: _openMenuSheet,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 54,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  color: theme.secondaryText,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Search services and support',
                                    style: theme.bodyMedium.copyWith(
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Semantics(
                        button: true,
                        label: 'View donation image',
                        child: InkWell(
                          onTap: _openDonationImage,
                          borderRadius: BorderRadius.circular(16),
                          child: Hero(
                            tag: 'homeDonationImage',
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 16 / 8.5,
                                child: Image.asset(
                                  'assets/images/aaaasxx.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _openDonationPage,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const FaIcon(
                          FontAwesomeIcons.solidHeart,
                          size: 16,
                        ),
                        label: const Text('Donate to keep our platform free'),
                      ),
                      const SizedBox(height: 28),
                      LayoutBuilder(
                        builder: (context, grid) {
                          const gap = 10.0;
                          final cardWidth = (grid.maxWidth - gap * 2) / 3;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: cardWidth,
                                child: _HomeFeatureCard(
                                  icon: Icons.hub_outlined,
                                  label: 'Connections',
                                  onTap: () => context
                                      .pushNamed(ConnectWidget.routeName),
                                ),
                              ),
                              const SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: _HomeFeatureCard(
                                  icon: Icons.verified_user_outlined,
                                  label: 'Verification',
                                  onTap: () => context.pushNamed(
                                      Verificationpage2Widget.routeName),
                                ),
                              ),
                              const SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: _HomeFeatureCard(
                                  icon: Icons.people_alt_outlined,
                                  label: 'Resources',
                                  onTap: () => context
                                      .pushNamed(ResourcesWidget.routeName),
                                ),
                              ),
                            ],
                          );
                        },
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

class _HomeFeatureCard extends StatelessWidget {
  const _HomeFeatureCard({
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
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: theme.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: theme.alternate),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 104),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: .09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: theme.primary, size: 23),
                ),
                const SizedBox(height: 9),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: theme.labelMedium.copyWith(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
