import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';
import '/custom_code/widgets/custom_loading_screen.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier, [Widget? entryPage]) =>
    GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? entryPage ?? const NavBarPage()
          : const SigninWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? entryPage ?? const NavBarPage()
              : const SigninWidget(),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          requireAuth: true,
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(
                  initialPage: 'Home',
                  disableResizeToAvoidBottomInset: true,
                )
              : const HomeWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => const SignUpWidget(),
        ),
        FFRoute(
          name: GetStartedpagWidget.routeName,
          path: GetStartedpagWidget.routePath,
          builder: (context, params) => const GetStartedpagWidget(),
        ),
        FFRoute(
          name: SigninWidget.routeName,
          path: SigninWidget.routePath,
          builder: (context, params) => const SigninWidget(),
        ),
        FFRoute(
          name: ForgotPasswordWidget.routeName,
          path: ForgotPasswordWidget.routePath,
          builder: (context, params) => const ForgotPasswordWidget(),
        ),
        FFRoute(
          name: SocialMediaAccountsWidget.routeName,
          path: SocialMediaAccountsWidget.routePath,
          builder: (context, params) => const SocialMediaAccountsWidget(),
        ),
        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          builder: (context, params) => const SettingsWidget(),
        ),
        FFRoute(
          name: Onboarding1Widget.routeName,
          path: Onboarding1Widget.routePath,
          builder: (context, params) => const Onboarding1Widget(),
        ),
        FFRoute(
          name: Onboarding2Widget.routeName,
          path: Onboarding2Widget.routePath,
          builder: (context, params) => const Onboarding2Widget(),
        ),
        FFRoute(
            name: ParentProfilesWidget.routeName,
            path: ParentProfilesWidget.routePath,
            builder: (context, params) => params.isEmpty
                ? const NavBarPage(
                    initialPage: 'ParentProfiles',
                    disableResizeToAvoidBottomInset: true,
                  )
                : const NavBarPage(
                    initialPage: 'ParentProfiles',
                    page: ParentProfilesWidget(),
                    disableResizeToAvoidBottomInset: true,
                  )),
        FFRoute(
            name: MyProfileWidget.routeName,
            path: MyProfileWidget.routePath,
            builder: (context, params) => params.isEmpty
                ? const NavBarPage(
                    initialPage: 'MyProfile',
                    disableResizeToAvoidBottomInset: true,
                  )
                : const NavBarPage(
                    initialPage: 'MyProfile',
                    page: MyProfileWidget(),
                    disableResizeToAvoidBottomInset: true,
                  )),
        FFRoute(
          name: ReportBlockUnblockWidget.routeName,
          path: ReportBlockUnblockWidget.routePath,
          builder: (context, params) => const ReportBlockUnblockWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => const NotificationsWidget(),
        ),
        FFRoute(
          name: ChangePasswordWidget.routeName,
          path: ChangePasswordWidget.routePath,
          builder: (context, params) => const ChangePasswordWidget(),
        ),
        FFRoute(
          name: ApprovedWidget.routeName,
          path: ApprovedWidget.routePath,
          builder: (context, params) => const ApprovedWidget(),
        ),
        FFRoute(
          name: ViewParentProfileWidget.routeName,
          path: ViewParentProfileWidget.routePath,
          builder: (context, params) => ViewParentProfileWidget(
            profileId: params.getParam(
              'profileId',
              ParamType.int,
            ),
            profilepicture: params.getParam(
              'profilepicture',
              ParamType.String,
            ),
            fullname: params.getParam(
              'fullname',
              ParamType.String,
            ),
            isverified: params.getParam(
              'isverified',
              ParamType.bool,
            ),
            country: params.getParam(
              'country',
              ParamType.String,
            ),
            state: params.getParam(
              'state',
              ParamType.String,
            ),
            age: params.getParam(
              'age',
              ParamType.String,
            ),
            gender: params.getParam(
              'gender',
              ParamType.String,
            ),
            bio: params.getParam(
              'bio',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AddDetailWidget.routeName,
          path: AddDetailWidget.routePath,
          builder: (context, params) => const AddDetailWidget(),
        ),
        FFRoute(
          name: ProfileSetupWidget.routeName,
          path: ProfileSetupWidget.routePath,
          requireAuth: true,
          builder: (context, params) => const ProfileSetupWidget(),
        ),
        FFRoute(
          name: Connected2Widget.routeName,
          path: Connected2Widget.routePath,
          builder: (context, params) => Connected2Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected3Widget.routeName,
          path: Connected3Widget.routePath,
          builder: (context, params) => Connected3Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected4Widget.routeName,
          path: Connected4Widget.routePath,
          builder: (context, params) => Connected4Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected5Widget.routeName,
          path: Connected5Widget.routePath,
          builder: (context, params) => Connected5Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected6Widget.routeName,
          path: Connected6Widget.routePath,
          builder: (context, params) => Connected6Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected7Widget.routeName,
          path: Connected7Widget.routePath,
          builder: (context, params) => Connected7Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: Connected8Widget.routeName,
          path: Connected8Widget.routePath,
          builder: (context, params) => Connected8Widget(
            connect: params.getParam(
              'connect',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: ConnectWidget.routeName,
          path: ConnectWidget.routePath,
          builder: (context, params) => const ConnectWidget(),
        ),
        FFRoute(
          name: ResourcesWidget.routeName,
          path: ResourcesWidget.routePath,
          builder: (context, params) => const ResourcesWidget(),
        ),
        FFRoute(
          name: EventsWidget.routeName,
          path: EventsWidget.routePath,
          builder: (context, params) => const EventsWidget(),
        ),
        FFRoute(
          name: DonateWidget.routeName,
          path: DonateWidget.routePath,
          builder: (context, params) => const DonateWidget(),
        ),
        FFRoute(
          name: MenuWidget.routeName,
          path: MenuWidget.routePath,
          builder: (context, params) => const MenuWidget(),
        ),
        FFRoute(
          name: AboutWidget.routeName,
          path: AboutWidget.routePath,
          builder: (context, params) => const AboutWidget(),
        ),
        FFRoute(
          name: OptverificatioWidget.routeName,
          path: OptverificatioWidget.routePath,
          builder: (context, params) => const OptverificatioWidget(),
        ),
        FFRoute(
          name: ViewProfileWidget.routeName,
          path: ViewProfileWidget.routePath,
          builder: (context, params) => ViewProfileWidget(
            userData: params.getParam<UsersRow>(
              'userData',
              ParamType.SupabaseRow,
            ),
            profilepicture: params.getParam(
              'profilepicture',
              ParamType.String,
            ),
            fullname: params.getParam(
              'fullname',
              ParamType.String,
            ),
            country: params.getParam(
              'country',
              ParamType.String,
            ),
            state: params.getParam(
              'state',
              ParamType.String,
            ),
            gender: params.getParam(
              'gender',
              ParamType.String,
            ),
            age: params.getParam(
              'age',
              ParamType.String,
            ),
            bio: params.getParam(
              'bio',
              ParamType.String,
            ),
            isverified: params.getParam(
              'isverified',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PrivacyWidget.routeName,
          path: PrivacyWidget.routePath,
          builder: (context, params) => const PrivacyWidget(),
        ),
        FFRoute(
          name: FQspageWidget.routeName,
          path: FQspageWidget.routePath,
          builder: (context, params) => const FQspageWidget(),
        ),
        FFRoute(
          name: SupportWidget.routeName,
          path: SupportWidget.routePath,
          builder: (context, params) => const SupportWidget(),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(
            profilepicture: params.getParam(
              'profilepicture',
              ParamType.String,
            ),
            fullname: params.getParam(
              'fullname',
              ParamType.String,
            ),
            country: params.getParam(
              'country',
              ParamType.String,
            ),
            state: params.getParam(
              'state',
              ParamType.String,
            ),
            age: params.getParam(
              'age',
              ParamType.String,
            ),
            gender: params.getParam(
              'gender',
              ParamType.String,
            ),
            bio: params.getParam(
              'bio',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ContactWidget.routeName,
          path: ContactWidget.routePath,
          builder: (context, params) => const ContactWidget(),
        ),
        FFRoute(
          name: CareerPageWidget.routeName,
          path: CareerPageWidget.routePath,
          builder: (context, params) => const CareerPageWidget(),
        ),
        FFRoute(
          name: SpansarWidget.routeName,
          path: SpansarWidget.routePath,
          builder: (context, params) => const SpansarWidget(),
        ),
        FFRoute(
          name: JobWidget.routeName,
          path: JobWidget.routePath,
          builder: (context, params) => const JobWidget(),
        ),
        FFRoute(
          name: OptVerificationPageWidget.routeName,
          path: OptVerificationPageWidget.routePath,
          builder: (context, params) => OptVerificationPageWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
            confirmPassword: params.getParam(
              'confirmPassword',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: FeedforumWidget.routeName,
          path: FeedforumWidget.routePath,
          builder: (context, params) => const FeedforumWidget(),
        ),
        FFRoute(
          name: AchatsWidget.routeName,
          path: AchatsWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(initialPage: 'achats')
              : const AchatsWidget(),
        ),
        FFRoute(
          name: ChatmessagesWidget.routeName,
          path: ChatmessagesWidget.routePath,
          builder: (context, params) => ChatmessagesWidget(
            chatRow: params.getParam<AChatSummaryRow>(
              'chatRow',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: IDVerificationWidget.routeName,
          path: IDVerificationWidget.routePath,
          builder: (context, params) => const IDVerificationWidget(),
        ),
        FFRoute(
          name: Verificationpage2Widget.routeName,
          path: Verificationpage2Widget.routePath,
          builder: (context, params) => params.isEmpty
              ? const NavBarPage(initialPage: 'Verificationpage2')
              : const Verificationpage2Widget(),
        ),
        FFRoute(
          name: PersonalIdentificationWidget.routeName,
          path: PersonalIdentificationWidget.routePath,
          builder: (context, params) => const PersonalIdentificationWidget(),
        ),
        FFRoute(
          name: AddressHistoryWidget.routeName,
          path: AddressHistoryWidget.routePath,
          builder: (context, params) => const AddressHistoryWidget(),
        ),
        FFRoute(
          name: AdditionalDetailsWidget.routeName,
          path: AdditionalDetailsWidget.routePath,
          builder: (context, params) => const AdditionalDetailsWidget(),
        ),
        FFRoute(
          name: PendingStatusWidget.routeName,
          path: PendingStatusWidget.routePath,
          builder: (context, params) => const PendingStatusWidget(),
        ),
        FFRoute(
          name: AdminVerificationWidget.routeName,
          path: AdminVerificationWidget.routePath,
          builder: (context, params) => const AdminVerificationWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return SigninWidget.routePath;
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child =
              appStateNotifier.loading ? const CustomLoadingScreen() : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
