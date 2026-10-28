import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:farmer_consultant/core/notification/notification_navigation_service.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_bloc.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_event.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_state.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  void _showOtpBottomSheet(String otp) {
    final loginBloc = context.read<LoginBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: loginBloc,
          child: _OtpBottomSheet(
            apiOtp: otp,
            mobileNo: mobileController.text.trim(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = context.appColors.primary;
    final lightBg = context.backgroundColor;

    return Scaffold(
      backgroundColor: lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _heroSection(),
          BlocConsumer<LoginBloc, LoginState>(
            listenWhen: (previous, current) =>
                previous.loginStatus != current.loginStatus,
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.success) {
                final String? otp = state.otp;

                if (state.loginModel == null &&
                    otp != null &&
                    otp.length == 4) {
                  FocusScope.of(context).unfocus();
                  _showOtpBottomSheet(otp);
                }
              }
              if (state.loginStatus == LoginStatus.failure &&
                  ModalRoute.of(context)?.isCurrent == true) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ??
                            AppLocalizations.of(context)!.getOtpError,
                        style: context.appTextStyles.body.copyWith(
                          color: context.appColors.onError,
                        ),
                      ),
                      backgroundColor: context.appColors.error,
                    ),
                  );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.35,
                            ),

                            Transform.translate(
                              offset: const Offset(0, -12),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  18,
                                  18,
                                  18,
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  color: context.cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.appColors.shadow
                                          .withValues(alpha: 0.08),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.login_rounded,
                                          color: primaryGreen,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(context)!.login,
                                          style: context
                                              .appTextStyles
                                              .headingMedium,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 18),

                                    const Divider(height: 1),

                                    SizedBox(height: 18),

                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.loginWithMobile,
                                      style: context.appTextStyles.bodyMedium,
                                    ),

                                    SizedBox(height: 16),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.cardBackgroundColor,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: context.borderColor,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            color: context.secondaryTextColor,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '+91',
                                            style: context
                                                .appTextStyles
                                                .labelLarge,
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 1,
                                            height: 24,
                                            color: context.borderColor,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: mobileController,
                                              style:
                                                  context.appTextStyles.input,
                                              keyboardType: TextInputType.phone,
                                              maxLength: 10,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              onChanged: (value) {
                                                if (value.length == 10) {
                                                  FocusScope.of(
                                                    context,
                                                  ).unfocus();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                counterText: '',
                                                hintText: AppLocalizations.of(
                                                  context,
                                                )!.enterMobileNumber,
                                                hintStyle: context
                                                    .appTextStyles
                                                    .inputHint,
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                filled: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 18),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed:
                                            state.loginStatus ==
                                                LoginStatus.sendOtploading
                                            ? null
                                            : () {
                                                final mobileNo =
                                                    mobileController.text
                                                        .trim();

                                                if (mobileController.text
                                                        .trim()
                                                        .length !=
                                                    10) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.invalidMobileNumber,
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                FocusScope.of(
                                                  context,
                                                ).unfocus();

                                                context.read<LoginBloc>().add(
                                                  GetOtpEvent(mobileNo),
                                                );
                                              },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryGreen,
                                          disabledBackgroundColor: primaryGreen,
                                          foregroundColor:
                                              context.appColors.onPrimary,
                                          disabledForegroundColor:
                                              context.appColors.onPrimary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child:
                                            state.loginStatus ==
                                                LoginStatus.sendOtploading
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(
                                                            context
                                                                .appColors
                                                                .onPrimary,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.sendingOtp,
                                                    style: context
                                                        .appTextStyles
                                                        .buttonLarge,
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.sendOtp,
                                                style: context
                                                    .appTextStyles
                                                    .buttonLarge,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // =======================================================
                            // BENEFITS SECTION
                            // =======================================================
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                18,
                                16,
                                18,
                              ),
                              decoration: BoxDecoration(
                                color: context.appTheme.inputBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.farmerConsultantBenefits,
                                    style: context.appTextStyles.sectionTitle,
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _BenefitItem(
                                          icon: Icons.grass_rounded,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.cropAdvisoryBenefit,
                                        ),
                                      ),
                                      Expanded(
                                        child: _BenefitItem(
                                          icon: Icons.cloudy_snowing,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.weatherUpdatesBenefit,
                                        ),
                                      ),
                                      Expanded(
                                        child: _BenefitItem(
                                          icon: Icons.bug_report_outlined,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.pestDiseaseAlertsBenefit,
                                        ),
                                      ),
                                      Expanded(
                                        child: _BenefitItem(
                                          icon: Icons.show_chart_rounded,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.marketRateInfoBenefit,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 15),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: context.cardBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: primaryGreen,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.dataPrivacyNotice,
                                      textAlign: TextAlign.center,
                                      style: context.appTextStyles.cardSubtitle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      /*
     
      */
    );
  }

  Widget _heroSection() {
    final heroHeight = (MediaQuery.sizeOf(context).height * 0.38).clamp(
      180.0,
      340.0,
    );

    return Stack(
      children: [
        // Farm background
        SizedBox(
          height: heroHeight,
          child: Image.asset(
            'assets/images/login_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),

        // RAI Logo
        Positioned(
          top: heroHeight * 0.12,
          left: 18.w,
          child: _raiLogo(heroHeight),
        ),
      ],
    );
  }

  // ============================================================
  // RAI LOGO
  // ============================================================

  Widget _raiLogo(double heroHeight) {
    final logoSize = heroHeight * 0.40;

    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: 0.55,
          heightFactor: 0.60,
          child: Image.asset(
            'assets/icons/logo.jpg',
            width: logoSize * 2,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BenefitItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = context.appColors.primary;

    return Column(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: context.cardBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: context.borderColor),
          ),
          child: Icon(icon, color: primaryGreen, size: 26),
        ),
        SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.appTextStyles.labelSmall,
        ),
      ],
    );
  }
}

class _OtpBottomSheet extends StatefulWidget {
  final String apiOtp;
  final String mobileNo;

  const _OtpBottomSheet({required this.apiOtp, required this.mobileNo});

  @override
  State<_OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<_OtpBottomSheet> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    final String otp = widget.apiOtp.trim();

    // Automatically fill all 4 fields.
    if (RegExp(r'^[0-9]{4}$').hasMatch(otp)) {
      for (int i = 0; i < 4; i++) {
        controllers[i].text = otp[i];
      }
    }
  }

  String get enteredOtp =>
      controllers.map((controller) => controller.text).join();

  void _verifyOtp() {
    final String otp = enteredOtp.trim();

    if (!RegExp(r'^\d{4}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalidOtp)),
      );
      return;
    }

    // Call Farmer Login API through BLoC.
    context.read<LoginBloc>().add(FarmerLoginEvent(widget.mobileNo, otp));
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = context.appColors.primary;

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.success) {
          final farmer = state.loginModel;

          if (farmer != null && farmer.status) {
            // Close the bottom sheet.
            final router = GoRouter.of(context);
            Navigator.of(context).pop();
            NotificationNavigationService.instance.completeAuthentication(
              router: router,
              farmerId: farmer.farmerId,
            );
          }
        }

        if (state.loginStatus == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? AppLocalizations.of(context)!.loginFailed,
                style: context.appTextStyles.body.copyWith(
                  color: context.appColors.onError,
                ),
              ),
              backgroundColor: context.appColors.error,
            ),
          );
        }
      },

      builder: (context, state) {
        final isLoading = state.loginStatus == LoginStatus.loginloading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.cardBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.verifyOtp,
                  style: context.appTextStyles.dialogTitle,
                ),

                SizedBox(height: 8),

                Text(
                  AppLocalizations.of(context)!.enterOtpHint,
                  style: context.appTextStyles.dialogBody,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 56,
                      child: TextField(
                        controller: controllers[index],
                        style: context.appTextStyles.input,
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: context.appColors.onPrimary,
                      disabledForegroundColor: context.appColors.onPrimary,
                      disabledBackgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.appColors.onPrimary,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.verifyingOtp,
                                style: context.appTextStyles.buttonLarge,
                              ),
                            ],
                          )
                        : Text(
                            AppLocalizations.of(context)!.verifyOtp,
                            style: context.appTextStyles.buttonLarge,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
