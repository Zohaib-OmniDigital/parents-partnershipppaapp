import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await SupaFlow.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => child!,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.entryPage});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  final Widget? entryPage;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late final StreamSubscription<BaseAuthUser> _userSubscription;
  late final StreamSubscription<String?> _jwtSubscription;
  late final StreamSubscription<AuthState> _authEventSubscription;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier, widget.entryPage);
    _userSubscription = parentsPartnershipSupabaseUserStream().listen(
      _appStateNotifier.update,
    );
    _jwtSubscription = jwtTokenStream.listen((_) {});
    _authEventSubscription = SupaFlow.client.auth.onAuthStateChange.listen(
      (data) {
        if (data.event == AuthChangeEvent.passwordRecovery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _router.goNamed(ChangePasswordWidget.routeName);
            }
          });
        }
      },
    );
    _splashTimer = Timer(
      const Duration(seconds: 2),
      _appStateNotifier.stopShowingSplashImage,
    );
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _userSubscription.cancel();
    _jwtSubscription.cancel();
    _authEventSubscription.cancel();
    _router.dispose();
    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title:
          'Parents Partnership provides resources and support in three key areas:',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF283D96),
          primary: const Color(0xFF283D96),
          secondary: const Color(0xFFEE2A7B),
          surface: Colors.white,
          error: const Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
          toolbarHeight: 64.h,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1D2748),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: const Color(0xFF1D2748),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE2EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE2EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF283D96), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD32F2F)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: Size(48.w, 48.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE8EBF0)),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 8,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF283D96),
          unselectedItemColor: const Color(0xFF7A8490),
          selectedLabelStyle:
              TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          interactive: true,
          radius: const Radius.circular(8),
          thickness: WidgetStateProperty.all(5),
        ),
      ),
      themeMode: _themeMode,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      backButtonDispatcher: _router.backButtonDispatcher,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  NavBarPageState createState() => NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  static const _tabNames = [
    'Home',
    'ParentProfiles',
    'Verificationpage2',
    'achats',
    'MyProfile',
  ];

  static const _tabPages = <Widget>[
    HomeWidget(),
    ParentProfilesWidget(),
    Verificationpage2Widget(),
    AchatsWidget(),
    MyProfileWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabNames.indexOf(_currentPageName).clamp(0, 4);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ??
          IndexedStack(index: currentIndex, children: _tabPages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = _tabNames[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 22.w,
            ),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.admin_panel_settings,
              size: 22.w,
            ),
            label: 'Parent Finder',
            tooltip: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.verified_user,
            ),
            label: 'Verification',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_sharp,
              size: 24.w,
            ),
            label: 'Message',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
              size: 22.w,
            ),
            label: 'My Profile',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
