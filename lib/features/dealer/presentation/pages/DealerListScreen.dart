import 'dart:async';

import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_text_styles.dart';
import 'package:farmer_consultant/core/utility/custom_loader.dart';
import 'package:farmer_consultant/core/utility/location_util.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_bloc.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_event.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final GlobalKey _dealerCallKey = GlobalKey();

  final GlobalKey _dealerEditKey = GlobalKey();

  final GlobalKey _dealerMapKey = GlobalKey();

  final GlobalKey _dealerWhatsAppKey = GlobalKey();
  bool _isOpeningDirections = false;
  @override
  void initState() {
    super.initState();

    _loadDealers();
  }

  bool _isLoading = false;
  String? _loadError;

  Future<void> _loadDealers() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final farmerId = (await SecureStorage.instance.getFarmerId()).trim();
      if (!mounted) return;
      if (farmerId.isEmpty || farmerId == '0') {
        throw Exception('Please sign in again to load nearby dealers.');
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
        _loadError = error.toString().replaceFirst('Exception: ', '');
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
      showError('Dealer location is not available. Please update it first.');
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
        showError(
          'Unable to get your location. Enable GPS and allow location access.',
        );
        return;
      }

      final uri = Uri.https('www.google.com', '/maps/dir/', {
        'api': '1',
        'origin': '${position.latitude},${position.longitude}',
        'destination': '$latitude,$longitude',
        'travelmode': 'driving',
      });
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) showError('Unable to open Google Maps. Please try again.');
    } catch (_) {
      showError('Unable to open directions. Please try again.');
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
          title: 'Near Dealer List',
          showProfile: false,
          showNotification: false,
          showThemeButton: true,
          onBackTap: _goBack,
        ),

        body: Column(
          children: [
            _buildLocationRow(),

            Expanded(
              child: BlocBuilder<DealerListBloc, DealerListState>(
                builder: (context, state) {
                  if (_isLoading || state.status == DealerListStatus.loading) {
                return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
                  }

                  if (_loadError != null ||
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
                              _loadError ??
                                  state.errorMessage ??
                                  'Something went wrong',
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
                              child: Text('Retry', style: AppTextStyles.button),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final dealers = state.dealerList;

                  return Column(
                    children: [
                      SizedBox(height: 16),
                      Expanded(
                        child: dealers.isEmpty
                            ? _buildEmptyView()
                            : RefreshIndicator(
                                onRefresh: _loadDealers,
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
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
                    ? 'Lat ${latitude.toStringAsFixed(5)}   |   Long ${longitude.toStringAsFixed(5)}'
                    : 'Location unavailable',
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
            'No dealers found nearby',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDealers,
            child: Text('Retry', style: AppTextStyles.button),
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
      showError('A valid dealer mobile number is not available.');
      return;
    }
    try {
      final opened = await launchUrl(
        Uri.https('wa.me', '/$number'),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) showError('Unable to open WhatsApp. Please try again.');
    } catch (_) {
      showError('Unable to open WhatsApp. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = dealer.outletName.trim();
    final mobile = dealer.outletPersonMobile?.trim() ?? '';

    final latitude = double.tryParse(dealer.latitude ?? '0') ?? 0;
    final longitude = double.tryParse(dealer.longitude ?? '0') ?? 0;
    final locationNotAvailable = latitude == 0 && longitude == 0;
    final outletDistance = double.tryParse(dealer.outletDistance ?? '');
    final definedRadius = double.tryParse(dealer.definedRadius ?? '');
    final showPin =
        outletDistance != null &&
        definedRadius != null &&
        outletDistance < definedRadius;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: context.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.borderColor, width: 3),
                ),
                child: Center(
                  child: Text(
                    name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                    style: AppTextStyles.pageTitle.copyWith(
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? 'Unknown dealer' : name,
                      style: AppTextStyles.listTitle.copyWith(
                        color: context.cardTextColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: 13,
                          color: context.secondaryTextColor,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            // 'Lat: ${dealer.latitude}  Long: ${dealer.longitude}',
                            'Lat: ${dealer.latitude}  Long: ${dealer.longitude}  (${dealer.outletDistance})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.helperText.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(height: 1, color: context.borderColor),
          ),

          Row(
            children: [
              Expanded(
                child: _DealerDetail(
                  icon: Icons.phone_outlined,
                  label: 'Mobile Number',
                  text: mobile.isEmpty ? 'Not available' : mobile,
                  onTap: mobile.isEmpty
                      ? null
                      : () {
                          callFarmer(mobile);
                        },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                key: mapKey,
                tooltip: 'Directions to dealer',
                onPressed: onMapTap,
                icon: Image.asset(
                  'assets/images/map.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.primaryColor.withValues(alpha: 0.08),
                  side: BorderSide(color: context.borderColor),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.outlined(
                key: whatsappKey,
                tooltip: 'Chat with dealer on WhatsApp',
                onPressed: () => _openWhatsApp(context),
                icon: SizedBox(
                  width: 22,
                  height: 22,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 22,
                        color: context.primaryColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Icon(
                          Icons.phone,
                          size: 13,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.primaryColor.withValues(alpha: 0.08),
                  side: BorderSide(color: context.borderColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          _DealerDetail(
            icon: Icons.location_on_outlined,
            label: 'Address',
            text: dealer.outletAddress.trim().isEmpty
                ? 'Address not available'
                : dealer.outletAddress.trim(),
          ),
        ],
      ),
    );
  }
}

// class _DealerDetail extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String text;
//   const _DealerDetail({
//     required this.icon,
//     required this.label,
//     required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             color: const Color(0xFFEDF5EF),
//             borderRadius: BorderRadius.circular(7),
//           ),
//           child: Icon(icon, size: 15, color: AppColors.primary),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 9,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 text,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   height: 1.25,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF18231C),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class _DealerDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final VoidCallback? onTap;

  const _DealerDetail({
    required this.icon,
    required this.label,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 15, color: context.primaryColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: AppTextStyles.buttonSmall.copyWith(
                    height: 1.25,
                    color: onTap != null
                        ? context.primaryColor
                        : context.cardTextColor,
                    decoration: onTap != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? dateTime;
  const _ActivityInfo({
    required this.icon,
    required this.title,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final raw = dateTime?.trim() ?? '';
    final missing = raw.isEmpty || raw.startsWith('0000-00-00');
    final parsed = missing ? null : DateTime.tryParse(raw);
    final value = missing
        ? 'Not recorded'
        : parsed == null
        ? raw
        : DateFormat('dd MMM yyyy').format(parsed);
    final time = parsed != null && raw.contains(RegExp(r'[T ]\d{2}:\d{2}'))
        ? DateFormat('h:mm a').format(parsed)
        : null;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: context.appTheme.inputBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: context.primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTextStyles.helperText.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
                if (time != null)
                  Text(
                    time,
                    style: AppTextStyles.helperText.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
