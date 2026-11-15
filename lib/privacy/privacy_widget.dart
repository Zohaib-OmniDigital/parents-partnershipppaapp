import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'privacy_model.dart';
export 'privacy_model.dart';

/// Create a Privacy policy page
///
class PrivacyWidget extends StatefulWidget {
  const PrivacyWidget({super.key});

  static String routeName = 'Privacy';
  static String routePath = '/privacy';

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget> {
  late PrivacyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrivacyModel());

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
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 22.0,
            buttonSize: 44.0,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Privacy Policy',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
              child: Scrollbar(
                controller: _model.columnController1,
                child: SingleChildScrollView(
                  controller: _model.columnController1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                            dragDevices: {
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.touch,
                              PointerDeviceKind.stylus,
                              PointerDeviceKind.unknown,
                            },
                          ),
                          child: Scrollbar(
                            controller: _model.columnController2,
                            child: SingleChildScrollView(
                              controller: _model.columnController2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/PP_App-removebg-preview.png',
                                      width: 274.5,
                                      height: 108.3,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    'Privacy Policy & Terms and Conditions\n',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmallFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .headlineSmallIsCustom,
                                        ),
                                  ),
                                  Divider(
                                    height: 2.0,
                                    thickness: 2.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Effective Date: January 26, 2024\n\nWelcome to Parents Partnership (the “Website”), a platform dedicated to fostering collaboration and support among parents. This Privacy Policy outlines how Parents Partnership (“we,” “us,” or “our”) collects, uses, protects, and shares information about users of our Website. By accessing or using our Website, you agree to the practices described in this Privacy Policy.\n\n1. Information Collection\n\nWe collect information from users in various ways, including, but not limited to:\n\nWhen you register on our Website, subscribe to a newsletter, respond to a survey, fill out a form, or communicate with us via email.\nThe types of personal information collected may include your name, email address, phone number, and other relevant details you choose to provide.\n2. Use of Information\n\nThe information we collect may be used in one of the following ways:\n\nTo personalize your experience on our Website and to allow us to deliver the type of content and offerings in which you are most interested.\nTo improve our Website based on the information and feedback we receive from you.\nTo improve customer service by effectively responding to your customer service requests and support needs.\nTo send periodic emails regarding your order or other products and services.\n3. Information Protection\n\nWe implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information. These measures include the use of SSL technology for data transmission and partnering with reputable hosting services to ensure the secure storage of data.\n\n4. Information Sharing\n\nParents Partnership does not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our Website, conducting our business, or servicing you, so long as those parties agree to keep this information confidential.\n\n5. Cookies and Tracking Technologies\n\nOur Website may use cookies and similar tracking technologies to enhance user experience, analyze trends, administer the Website, and gather demographic information about our user base as a whole. You can choose to have your computer warn you each time a cookie is being sent, or you can choose to turn off all cookies via your browser settings.\n\n6. Your Rights\n\nYou have the right to access, correct, or delete your personal information under our control. If you wish to exercise these rights, please contact us at the provided contact information.\n\n7. Changes to This Privacy Policy\n\nWe reserve the right to update or change our Privacy Policy at any time. We will post any Privacy Policy changes on this page and encourage you to review it periodically.\n\n8. Contact Us\n\nIf you have any questions regarding this Privacy Policy, you may contact us using the information below:\n\nEmail: jenny@parentspartnership.org\n\nConsent\n\nBy using our Website, you hereby consent to our Privacy Policy and agree to its terms.\n\nEffective Date: January 26, 2024\n\nWelcome to Parents Partnership (the “Website”), a platform dedicated to fostering collaboration and support among parents. This Privacy Policy outlines how Parents Partnership (“we,” “us,” or “our”) collects, uses, protects, and shares information about users of our Website. By accessing or using our Website, you agree to the practices described in this Privacy Policy.\n\n1. Information Collection\n\nWe collect information from users in various ways, including, but not limited to:\n\nWhen you register on our Website, subscribe to a newsletter, respond to a survey, fill out a form, or communicate with us via email.\nThe types of personal information collected may include your name, email address, phone number, and other relevant details you choose to provide.\n2. Use of Information\n\nThe information we collect may be used in one of the following ways:\n\nTo personalize your experience on our Website and to allow us to deliver the type of content and offerings in which you are most interested.\nTo improve our Website based on the information and feedback we receive from you.\nTo improve customer service by effectively responding to your customer service requests and support needs.\nTo send periodic emails regarding your order or other products and services.\n3. Information Protection\n\nWe implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information. These measures include the use of SSL technology for data transmission and partnering with reputable hosting services to ensure the secure storage of data.\n\n4. Information Sharing\n\nParents Partnership does not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our Website, conducting our business, or servicing you, so long as those parties agree to keep this information confidential.\n\n5. Cookies and Tracking Technologies\n\nOur Website may use cookies and similar tracking technologies to enhance user experience, analyze trends, administer the Website, and gather demographic information about our user base as a whole. You can choose to have your computer warn you each time a cookie is being sent, or you can choose to turn off all cookies via your browser settings.\n\n6. Your Rights\n\nYou have the right to access, correct, or delete your personal information under our control. If you wish to exercise these rights, please contact us at the provided contact information.\n\n7. Changes to This Privacy Policy\n\nWe reserve the right to update or change our Privacy Policy at any time. We will post any Privacy Policy changes on this page and encourage you to review it periodically.\n\n8. Contact Us\n\nIf you have any questions regarding this Privacy Policy, you may contact us using the information below:\n\nEmail: jenny@parentspartnership.org\n\nConsent\n\nBy using our Website, you hereby consent to our Privacy Policy and agree to its terms.\n\nEffective Date: January 26, 2024\n\nWelcome to Parents Partnership (the “Website”), a platform dedicated to fostering collaboration and support among parents. This Privacy Policy outlines how Parents Partnership (“we,” “us,” or “our”) collects, uses, protects, and shares information about users of our Website. By accessing or using our Website, you agree to the practices described in this Privacy Policy.\n\n1. Information Collection\n\nWe collect information from users in various ways, including, but not limited to:\n\nWhen you register on our Website, subscribe to a newsletter, respond to a survey, fill out a form, or communicate with us via email.\nThe types of personal information collected may include your name, email address, phone number, and other relevant details you choose to provide.\n2. Use of Information\n\nThe information we collect may be used in one of the following ways:\n\nTo personalize your experience on our Website and to allow us to deliver the type of content and offerings in which you are most interested.\nTo improve our Website based on the information and feedback we receive from you.\nTo improve customer service by effectively responding to your customer service requests and support needs.\nTo send periodic emails regarding your order or other products and services.\n3. Information Protection\n\nWe implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information. These measures include the use of SSL technology for data transmission and partnering with reputable hosting services to ensure the secure storage of data.\n\n4. Information Sharing\n\nParents Partnership does not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our Website, conducting our business, or servicing you, so long as those parties agree to keep this information confidential.\n\n5. Cookies and Tracking Technologies\n\nOur Website may use cookies and similar tracking technologies to enhance user experience, analyze trends, administer the Website, and gather demographic information about our user base as a whole. You can choose to have your computer warn you each time a cookie is being sent, or you can choose to turn off all cookies via your browser settings.\n\n6. Your Rights\n\nYou have the right to access, correct, or delete your personal information under our control. If you wish to exercise these rights, please contact us at the provided contact information.\n\n7. Changes to This Privacy Policy\n\nWe reserve the right to update or change our Privacy Policy at any time. We will post any Privacy Policy changes on this page and encourage you to review it periodically.\n\n8. Contact Us\n\nIf you have any questions regarding this Privacy Policy, you may contact us using the information below:\n\nEmail: jenny@parentspartnership.org\n\nConsent\n\nBy using our Website, you hereby consent to our Privacy Policy and agree to its terms.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 1.6,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Terms and Conditions\n',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .headlineSmallIsCustom,
                                            ),
                                      ),
                                      Divider(
                                        height: 2.0,
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                      Text(
                                        'Last Updated: 5/1/2025\n\nWelcome to Parents Partnership! By accessing or using our website or app, you agree to the following terms. Please read them carefully.\n\n1. Who Can Use the Platform\n\nThis platform is open to users 13 years and older.\nUsers under 15 should have parental or guardian permission to join.\nWe do not have a verification system for age, so parents: please supervise your child’s usage.\n2. Community Guidelines\n\nWe are committed to maintaining a respectful, helpful environment for all types of families—parents, grandparents, foster families, kinship caregivers, and more.\n\nBy using our platform, you agree to:\n\nBe kind, civil, and constructive.\nAvoid harassment, hate speech, bullying, or threatening language.\nStay on topic and respect other users’ perspectives.\nNot post misleading, fraudulent, or illegal content.\nRespect category organization (we may move your post if it fits better elsewhere).\nFailure to follow these guidelines may result in content removal, suspension, or permanent bans at our discretion.\n\n3. Moderation and AI Tools\n\nWe use a combination of human moderators and AI tools to keep the platform safe and welcoming. AI may flag content for review, assist with moderation decisions, or temporarily hide comments that violate guidelines.\n\nModerators may:\n\nReframe comments for clarity.\nTurn off commenting on heated threads.\nBan accounts for repeated or severe violations.\n4. Content Ownership\n\nYou own the content you create.\nBy posting on our platform, you grant us a non-exclusive, royalty-free license to display, distribute, and promote your content as part of our services.\nDo not upload anything you don’t have the right to share.\n5. Intellectual Property\n\nAll trademarks, logos, and content on this site (aside from user submissions) are property of Parents Partnership and may not be used without permission.\n\n6. External Links & Resources\n\nWe may include third-party resources, affiliate links, or references for your convenience. We don’t control these and are not responsible for their content, practices, or availability.\n\n7. Disclaimer of Liability\n\nThis platform is provided “as is.” We are not liable for:\n\nAny damages caused by using or not being able to use the platform.\nThe accuracy or usefulness of any posted content.\nAny actions taken based on information found here.\nAlways consult a professional (legal, medical, or otherwise) when appropriate.\n\n8. Changes to the Platform\n\nWe reserve the right to update, modify, or remove features at any time without prior notice. Major policy changes will be announced, but continued use implies agreement to the updated terms.\n\n9. DMCA & Takedown Requests\n\nIf you believe content on our platform infringes on your copyright, please send a takedown request to: info@parentspartnership.org with:\n\nYour contact info\nDescription of the copyrighted work\nURL of the alleged infringement\nA statement that you believe in good faith it is not authorized\nYour physical or electronic signature\n10. Contact Us\n\nFor questions, feedback, or moderation concerns, contact us at:\n📧 info@parentspartnership.org\n\n11. Jurisdiction\n\nThese terms are governed by the laws of the United States and the state in which Parents Partnership is headquartered. Users are responsible for complying with local laws in their area.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 1.6,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Divider(
                                    height: 2.0,
                                    thickness: 2.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ]
                                    .divide(const SizedBox(height: 24.0))
                                    .addToStart(const SizedBox(height: 24.0))
                                    .addToEnd(const SizedBox(height: 40.0)),
                              ),
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
