import 'package:flutter/material.dart';

import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'notifications_model.dart';

export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static const String routeName = 'Notifications';
  static const String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());
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
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: context.safePop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Notification settings',
            onPressed: () => context.pushNamed(SettingsWidget.routeName),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SafeArea(
        top: false,
        child: AppEmptyState(
          icon: Icons.notifications_none_rounded,
          title: 'You’re all caught up',
          message:
              'New messages, connection updates, and account alerts will appear here.',
        ),
      ),
    );
  }
}
