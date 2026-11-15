import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'resources_model.dart';
export 'resources_model.dart';

class ResourcesWidget extends StatefulWidget {
  const ResourcesWidget({super.key});

  static String routeName = 'RESOURCES';
  static String routePath = '/resources';

  @override
  State<ResourcesWidget> createState() => _ResourcesWidgetState();
}

class _ResourcesWidgetState extends State<ResourcesWidget> {
  late ResourcesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResourcesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).tertiary,
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: LayoutBuilder(
            builder: (context, constraints) => FlutterFlowWebView(
              content: 'https://parentspartnership.org/resource-finder/',
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              verticalScroll: true,
              horizontalScroll: true,
            ),
          ),
        ),
      ),
    );
  }
}
