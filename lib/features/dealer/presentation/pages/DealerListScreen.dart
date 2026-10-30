import 'dart:async';
import 'package:farmer_consultant/l10n/app_localizations.dart';

import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_text_styles.dart';

import 'package:farmer_consultant/core/utility/location_util.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_bloc.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_event.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:url_launcher/url_launcher.dart';

class DealerListScreen extends StatefulWidget {
  const DealerListScreen({super.key});

  @override
  State<DealerListScreen> createState() => _DealerListScreenState();
}

class _DealerListScreenState extends State<DealerListScreen> {
  String? _currentLatitude;
  String? _currentLongitude;

  final GlobalKey _dealerPinKey = GlobalKey();

  final GlobalKey _dealerMapKey = GlobalKey();

  final GlobalKey _dealerWhatsAppKey = GlobalKey();
  bool _isOpeningDirections = false;
  @override
  void initState() {
    super.initState();

    _loadDealers();
  }

  bool _isLoading = false;
  bool _loadFailed = false;
  bool _requiresSignIn = false;

  Future<void> _loadDealers() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _loadFailed = false;
      _requiresSignIn = false;
    });
    try {
      final farmerId = (await SecureStorage.instance.getFarmerId()).trim();
      if (!mounted) return;
      if (farmerId.isEmpty || farmerId == '0') {
        _requiresSignIn = true;
        return;
      }
      final position = await LocationUtil.instance.getCurrentLocation().timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );
      if (!mounted) return;
      _currentLatitude = position?.latitude.toString();
      _currentLongitude = position?.longitude.toString();
      final bloc = context.read<DealerListBloc>();
      final completed = bloc.stream.firstWhere(
        (state) =>
            state.status == DealerListStatus.success ||
            state.status == DealerListStatus.failure,
      );
      bloc.add(
        DealerListEvent(
          farmerId: farmerId,
          latitude: _currentLatitude ?? '',
          longitude: _currentLongitude ?? '',
        ),
      );
      await completed;
    } catch (error) {
      if (mounted) {
        _loadFailed = true;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _openDealerDirections(DealerListModel dealer) async {
    if (_isOpeningDirections) return;
    final strings = AppLocalizations.of(context)!;

    void showError(String message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: AppTextStyles.body)),
      );
    }

    final latitude = double.tryParse(dealer.latitude?.trim() ?? '');
    final longitude = double.tryParse(dealer.longitude?.trim() ?? '');
    if (latitude == null ||
        longitude == null ||
        !latitude.isFinite ||
        !longitude.isFinite ||
        latitude.abs() > 90 ||
        longitude.abs() > 180 ||
        (latitude == 0 && longitude == 0)) {
      showError(strings.dealerLocationUnavailable);
      return;
    }

    setState(() => _isOpeningDirections = true);
    try {
      final position = await LocationUtil.instance.getCurrentLocation().timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );
      if (!mounted) return;
      if (position == null) {
        showError(strings.locationAccessError);
        return;
      }

      final uri = Uri.https('www.google.com', '/maps/dir/', {
        'api': '1',
        'origin': '${position.latitude},${position.longitude}',
        'destination': '$latitude,$longitude',
        'travelmode': 'driving',
      });
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) showError(strings.unableToOpenMaps);
    } catch (_) {
      showError(strings.unableToOpenDirections);
    } finally {
      if (mounted) setState(() => _isOpeningDirections = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBack();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CommonDashboardAppBar(
          title: AppLocalizations.of(context)!.nearDealers,
          showProfile: false,
          showNotification: false,
          showThemeButton: true,
          onBackTap: _goBack,
        ),

        body: Column(
          children: [
            // _buildLocationRow(),
            Expanded(
              child: BlocBuilder<DealerListBloc, DealerListState>(
                builder: (context, state) {
                  if (_isLoading || state.status == DealerListStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }

                  if (_loadFailed ||
                      _requiresSignIn ||
                      state.status == DealerListStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 50,
                              color: context.appColors.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _requiresSignIn
                                  ? AppLocalizations.of(
                                      context,
                                    )!.dealerSignInRequired
                                  : AppLocalizations.of(
                                      context,
                                    )!.dealerLoadError,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadDealers,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.primaryColor,
                                foregroundColor: context.onPrimaryColor,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.retry,
                                style: AppTextStyles.button,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final dealers = state.dealerList;

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Expanded(
                        child: dealers.isEmpty
                            ? _buildEmptyView()
                            : RefreshIndicator(
                                onRefresh: _loadDealers,
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  itemCount: dealers.length,
                                  itemBuilder: (context, index) {
                                    final dealer = dealers[index];

                                    return _DealerListItem(
                                      dealer: dealer,

                                      pinKey: index == 0 ? _dealerPinKey : null,

                                      mapKey: index == 0 ? _dealerMapKey : null,

                                      whatsappKey: index == 0
                                          ? _dealerWhatsAppKey
                                          : null,

                                      onMapTap: _isOpeningDirections
                                          ? null
                                          : () {
                                              _openDealerDirections(dealer);
                                            },

                                      // onLocationTap: () {
                                      //   _submitDealerLocation(dealer);
                                      // },
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow() {
    final latitude = double.tryParse(_currentLatitude ?? '');
    final longitude = double.tryParse(_currentLongitude ?? '');
    final hasLocation = latitude != null && longitude != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.my_location_rounded,
              size: 13,
              color: context.primaryColor,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                hasLocation
                    ? AppLocalizations.of(context)!.locationCoordinates(
                        latitude.toStringAsFixed(5),
                        longitude.toStringAsFixed(5),
                      )
                    : AppLocalizations.of(context)!.locationUnavailable,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.store_outlined,
            size: 48,
            color: context.secondaryTextColor,
          ),

          const SizedBox(height: 12),

          Text(
            AppLocalizations.of(context)!.noNearbyDealers,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDealers,
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }
}

class _DealerListItem extends StatelessWidget {
  final DealerListModel dealer;
  // final VoidCallback onLocationTap;
  final VoidCallback? onMapTap;
  final Key? pinKey;

  final Key? mapKey;
  final Key? whatsappKey;
  const _DealerListItem({
    required this.dealer,
    // required this.onLocationTap,
    required this.onMapTap,
    this.pinKey,

    this.mapKey,
    this.whatsappKey,
  });

  Future<void> _openWhatsApp(BuildContext context) async {
    final strings = AppLocalizations.of(context)!;
    String normalize(String? value) {
      var number = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
      if (number.startsWith('00')) {
        number = number.substring(2);
      }
      if (number.length == 11 && number.startsWith('0')) {
        number = number.substring(1);
      }
      if (number.length == 10) {
        number = '91$number';
      }
      return number;
    }

    bool isValid(String number) =>
        RegExp(r'^[1-9][0-9]{10,14}$').hasMatch(number);
    var number = normalize(dealer.outletPersonMobile);
    if (!isValid(number)) number = normalize(dealer.outletMobile);
    void showError(String message) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: AppTextStyles.body)),
      );
    }

    if (!isValid(number)) {
      showError(strings.dealerMobileUnavailable);
      return;
    }
    try {
      final opened = await launchUrl(
        Uri.https('wa.me', '/$number'),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) showError(strings.unableToOpenWhatsApp);
    } catch (_) {
      showError(strings.unableToOpenWhatsApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = dealer.outletName.trim();
    final person = dealer.outletPerson.trim();
    final primaryMobile = dealer.outletPersonMobile?.trim() ?? '';
    final mobile = primaryMobile.isNotEmpty
        ? primaryMobile
        : dealer.outletMobile?.trim() ?? '';
    final address = dealer.outletAddress.trim();
    final distance = double.tryParse(dealer.outletDistance?.trim() ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: context.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty
                          ? AppLocalizations.of(context)!.unknownDealer
                          : name,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: context.cardTextColor,
                        height: 1.25,
                        fontSize: 17,
                      ),
                    ),
                    if (distance != null &&
                        distance.isFinite &&
                        distance >= 0) ...[
                      const SizedBox(height: 3),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.dealerDistanceAway(distance.toStringAsFixed(1)),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _DealerDetail(
            icon: Icons.location_on_outlined,
            text: address.isEmpty
                ? AppLocalizations.of(context)!.addressUnavailable
                : address,
          ),
          const SizedBox(height: 8),
          _DealerDetail(
            icon: Icons.phone_outlined,
            onTap: mobile.isEmpty ? null : () => callFarmer(mobile),
            text: [
              if (person.isNotEmpty) person,
              mobile.isEmpty
                  ? AppLocalizations.of(context)!.mobileNumberUnavailable
                  : mobile,
            ].join(' | '),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              FilledButton.icon(
                onPressed: mobile.isEmpty ? null : () => callFarmer(mobile),
                style: FilledButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: context.onPrimaryColor,
                  minimumSize: const Size(0, 36),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.padded,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.call_outlined, size: 16),
                label: Text(
                  AppLocalizations.of(context)!.call,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              OutlinedButton.icon(
                key: mapKey,
                onPressed: onMapTap,
                style: _actionStyle(context),
                icon: const Icon(Icons.directions_outlined, size: 16),
                label: Text(
                  AppLocalizations.of(context)!.directions,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              OutlinedButton.icon(
                key: whatsappKey,
                onPressed: mobile.isEmpty ? null : () => _openWhatsApp(context),
                style: _actionStyle(context),
                icon: const Icon(Icons.chat_outlined, size: 16),
                label: Text(
                  AppLocalizations.of(context)!.whatsApp,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ButtonStyle _actionStyle(BuildContext context) => OutlinedButton.styleFrom(
    foregroundColor: context.primaryColor,
    side: BorderSide(color: context.borderColor),
    minimumSize: const Size(0, 36),
    visualDensity: VisualDensity.compact,
    tapTargetSize: MaterialTapTargetSize.padded,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

class _DealerDetail extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _DealerDetail({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final detail = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: context.secondaryTextColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.secondaryTextColor,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
    return onTap == null ? detail : InkWell(onTap: onTap, child: detail);
  }
}

String getCurrentTime() {
  final now = DateTime.now();

  int hour = now.hour;

  final minute = now.minute;

  String period = "AM";

  if (hour >= 12) {
    period = "PM";

    if (hour > 12) {
      hour -= 12;
    }
  }

  if (hour == 0) {
    hour = 12;
  }

  final formattedHour = hour.toString().padLeft(2, '0');

  final formattedMinute = minute.toString().padLeft(2, '0');

  return "$formattedHour:"
      "$formattedMinute "
      "$period";
}

Future<void> callFarmer(String phone) async {
  final phoneUri = Uri(scheme: 'tel', path: phone);

  if (!await canLaunchUrl(phoneUri)) {
    debugPrint('Unable to open dialer for phone number: $phone');
    return;
  }

  final launched = await launchUrl(
    phoneUri,
    mode: LaunchMode.externalApplication,
  );

  if (!launched) {
    debugPrint('Failed to open dialer for phone number: $phone');
  }
}
