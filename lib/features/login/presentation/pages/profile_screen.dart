import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/core/localization/language_provider.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

// Add your existing imports for:
// SecureStorage
// CommonDashboardAppBar
// Theme extensions (context.primaryColor, etc.)

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _mobile = '';
  String _address = '';
  String _taluka = '';
  String _state = '';

  bool _isLoading = true;
  bool _addressExpanded = false;
  bool _savingLanguage = false;
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    try {
      await SecureStorage.instance.clearUserData();
      if (!mounted) return;
      context.go(AppRouter.login);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.logoutError)),
      );
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  static const _languages = [
    (code: 'en', name: 'English', subtitle: 'English'),
    (code: 'mr', name: 'मराठी', subtitle: 'Marathi'),
    (code: 'hi', name: 'हिन्दी', subtitle: 'Hindi'),
  ];

  Future<void> _selectLanguage() async {
    final provider = LanguageScope.of(context);
    final strings = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.selectLanguage,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                strings.languageHint,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              for (final language in _languages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                    checked: language.code == provider.currentLanguageCode,
                    inMutuallyExclusiveGroup: true,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: language.code == provider.currentLanguageCode
                              ? sheetContext.primaryColor
                              : sheetContext.borderColor,
                        ),
                      ),
                      selected: language.code == provider.currentLanguageCode,
                      selectedTileColor:
                          sheetContext.appColors.primaryContainer,
                      title: Text(language.name),
                      subtitle: language.code == 'en'
                          ? null
                          : Text(language.subtitle),
                      trailing: Icon(
                        language.code == provider.currentLanguageCode
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: language.code == provider.currentLanguageCode
                            ? sheetContext.primaryColor
                            : sheetContext.secondaryTextColor,
                      ),
                      onTap: () => Navigator.pop(sheetContext, language.code),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (!mounted ||
        selected == null ||
        selected == provider.currentLanguageCode) {
      return;
    }
    setState(() => _savingLanguage = true);
    try {
      await provider.changeLanguage(selected);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageSaveError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _savingLanguage = false);
    }
  }

  Widget _buildLanguageCard() {
    final strings = AppLocalizations.of(context)!;
    final provider = LanguageScope.of(context);
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) => Material(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.translate_rounded, color: context.primaryColor),
          ),
          title: Text(strings.language, style: context.appTextStyles.cardTitle),
          subtitle: Text(
            _languages
                .firstWhere(
                  (language) => language.code == provider.currentLanguageCode,
                )
                .name,
          ),
          trailing: _savingLanguage
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right_rounded),
          onTap: _savingLanguage ? null : _selectLanguage,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final userData = await SecureStorage.instance.getUserData();

      if (!mounted) return;

      setState(() {
        _name = _value(userData?['fld_farmer_name']);
        _mobile = _value(userData?['fld_mobile_no']);
        _address = _value(userData?['fld_address']);
        _taluka = _value(userData?['taluka_name']);
        _state = _value(userData?['state_name']);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('PROFILE LOAD ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String _value(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  String _display(String value) {
    return value.trim().isEmpty
        ? AppLocalizations.of(context)!.notAvailable
        : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonDashboardAppBar(
        title: AppLocalizations.of(context)!.profile,
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: context.primaryColor),
            )
          : RefreshIndicator(
              color: context.primaryColor,
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    SizedBox(height: 12.h),
                    _buildDetailsCard(),
                    SizedBox(height: 16.h),
                    _buildLanguageCard(),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoggingOut ? null : _logout,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        icon: _isLoggingOut
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.logout_rounded),
                        label: Text(AppLocalizations.of(context)!.logout),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 36.sp,
              color: context.primaryColor,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            _display(_name),
            textAlign: TextAlign.center,
            style: context.appTextStyles.cardTitle.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),

          SizedBox(height: 4.h),

          if (_mobile.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 15.sp,
                  color: context.secondaryTextColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  _mobile,
                  style: context.appTextStyles.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),

          // SizedBox(height: 14.h),

          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          //   decoration: BoxDecoration(
          //     color: context.primaryColor.withValues(alpha: 0.08),
          //     borderRadius: BorderRadius.circular(20.r),
          //   ),
          //   child: Text(
          //     'Farmer ID: ${_display(_farmerId)}',
          //     style: context.appTextStyles.labelSmall.copyWith(
          //       color: context.primaryColor,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ================= DETAILS CARD =================

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.personalInformation,
            style: context.appTextStyles.cardTitle.copyWith(
              color: context.primaryTextColor,
            ),
          ),

          SizedBox(height: 6.h),

          // _profileItem(Icons.badge_outlined, 'Farmer ID', _farmerId),

          // _divider(),
          _profileItem(
            Icons.person_outline_rounded,
            AppLocalizations.of(context)!.fullName,
            _name,
          ),

          _divider(),

          _profileItem(
            Icons.phone_outlined,
            AppLocalizations.of(context)!.mobileNumber,
            _mobile,
          ),

          _divider(),

          _profileItem(
            Icons.map_outlined,
            AppLocalizations.of(context)!.state,
            _state,
          ),

          _divider(),

          _profileItem(
            Icons.location_city_outlined,
            AppLocalizations.of(context)!.taluka,
            _taluka,
          ),

          _divider(),

          _profileItem(
            Icons.location_on_outlined,
            AppLocalizations.of(context)!.address,
            _address,
            expandable: true,
            isExpanded: _addressExpanded,
            onTap: () {
              setState(() {
                _addressExpanded = !_addressExpanded;
              });
            },
          ),
        ],
      ),
    );
  }

  // ================= PROFILE ITEM =================

  Widget _profileItem(
    IconData icon,
    String title,
    String value, {
    bool expandable = false,
    bool isExpanded = false,
    VoidCallback? onTap,
  }) {
    final bool hasValue = value.trim().isNotEmpty;

    return InkWell(
      onTap: expandable && hasValue ? onTap : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: context.primaryColor, size: 20.sp),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.appTextStyles.labelSmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topLeft,
                    child: Text(
                      _display(value),
                      maxLines: expandable ? (isExpanded ? null : 2) : null,
                      overflow: expandable && !isExpanded
                          ? TextOverflow.ellipsis
                          : null,
                      style: context.appTextStyles.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // if (expandable && hasValue)
                  //   Padding(
                  //     padding: EdgeInsets.only(top: 5.h),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Text(
                  //           isExpanded ? 'Show less' : 'Show more',
                  //           style: context.appTextStyles.helperText.copyWith(
                  //             color: context.primaryColor,
                  //           ),
                  //         ),
                  //         SizedBox(width: 2.w),
                  //         Icon(
                  //           isExpanded
                  //               ? Icons.keyboard_arrow_up_rounded
                  //               : Icons.keyboard_arrow_down_rounded,
                  //           size: 16.sp,
                  //           color: context.primaryColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DIVIDER =================

  Widget _divider() {
    return Divider(height: 1, thickness: 0.7, color: context.borderColor);
  }
}
