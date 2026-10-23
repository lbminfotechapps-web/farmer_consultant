import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Add your existing project imports:
// crop_bloc.dart
// crop_event.dart
// crop_state.dart
// secure_storage.dart
// common_dashboard_app_bar.dart
// schedule_by_plot_entity.dart

// class CropSchedulByPlot extends StatefulWidget {
//   final String plotId;

//   const CropSchedulByPlot({super.key, required this.plotId});

//   @override
//   State<CropSchedulByPlot> createState() => _CropSchedulByPlotState();
// }

// class _CropSchedulByPlotState extends State<CropSchedulByPlot> {
//   late final CropBloc _scheduleBloc;
//   final ScrollController _scrollController = ScrollController();
//   String _farmerId = '';
//   String? _localError;
//   bool _loadingFarmer = true;

//   bool _answerBusy = false;
//   String? _updatingScheduleId;

//   Future<void> _confirmApplied(String scheduleId) async {
//     if (_answerBusy || _scheduleBloc.state.loadingMore) return;
//     setState(() => _answerBusy = true);
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Confirm products applied'),
//         content: const Text('Have you applied all products in this schedule?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext, false),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(dialogContext, true),
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//     if (!mounted) return;
//     if (confirmed != true) {
//       setState(() => _answerBusy = false);
//       return;
//     }

//     setState(() => _updatingScheduleId = scheduleId);

//     // Isolate update results from list loading and pagination state.
//     final updateBloc = CropBloc(
//       cropScheduleUsecases: _scheduleBloc.cropScheduleUsecases,
//     );
//     try {
//       final completion = updateBloc.stream.firstWhere(
//         (state) =>
//             state.cropStatus == CropStatus.success ||
//             state.cropStatus == CropStatus.failure,
//       );
//       updateBloc.add(
//         UpdateScheduleStatus(farmerId: _farmerId, scheduleId: scheduleId),
//       );
//       final result = await completion;
//       if (!mounted) return;
//       if (result.cropStatus == CropStatus.success) {
//         if (_scrollController.hasClients) _scrollController.jumpTo(0);
//         _loadSchedules();
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             result.errorMessage ??
//                 (result.cropStatus == CropStatus.success
//                     ? 'Schedule updated successfully'
//                     : 'Unable to update schedule'),
//           ),
//         ),
//       );
//     } finally {
//       await updateBloc.close();
//       if (mounted) {
//         setState(() {
//           _answerBusy = false;
//           _updatingScheduleId = null;
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _scheduleBloc = CropBloc(
//       cropScheduleUsecases: context.read<CropBloc>().cropScheduleUsecases,
//     );
//     _initialize();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _scheduleBloc.close();
//     super.dispose();
//   }

//   Future<void> _initialize() async {
//     try {
//       if (widget.plotId.trim().isEmpty) {
//         throw Exception('Plot ID is missing');
//       }

//       final farmerId = await SecureStorage.instance.getFarmerId();

//       if (!mounted) return;

//       if (farmerId.isEmpty || farmerId == '0') {
//         throw Exception('Please login again');
//       }

//       setState(() {
//         _farmerId = farmerId;
//         _loadingFarmer = false;
//         _localError = null;
//       });

//       _loadSchedules();
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         _loadingFarmer = false;
//         _localError = e.toString();
//       });
//     }
//   }

//   void _onScroll() {
//     if (_answerBusy) return;
//     // The reversed list starts at the latest schedule at the bottom.
//     // Its trailing extent is the older history above the current viewport.
//     if (_scrollController.position.extentAfter < 200 &&
//         _scheduleBloc.state.paginationError == null) {
//       _loadSchedules(loadMore: true);
//     }
//   }

//   void _loadSchedules({bool loadMore = false}) {
//     final state = _scheduleBloc.state;
//     if (_farmerId.isEmpty ||
//         state.loadingMore ||
//         state.cropStatus == CropStatus.loading ||
//         (loadMore &&
//             (!state.hasMoreSchedules || state.scheduleByPlotList.isEmpty))) {
//       return;
//     }

//     _scheduleBloc.add(
//       GetCropScheduleByPlotListEvent(
//         _farmerId,
//         widget.plotId,
//         startLimit: loadMore ? state.nextScheduleOffset.toString() : '0',
//       ),
//     );
//   }

//   Future<void> _refreshSchedules() async {
//     if (_answerBusy) return;
//     if (_scheduleBloc.state.loadingMore) return;
//     if (_farmerId.isEmpty) {
//       await _initialize();
//       return;
//     }

//     final bloc = _scheduleBloc;

//     final completion = bloc.stream.firstWhere(
//       (state) =>
//           state.cropStatus == CropStatus.success ||
//           state.cropStatus == CropStatus.failure,
//     );

//     _loadSchedules();

//     await completion;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,

//       appBar: CommonDashboardAppBar(
//         title: 'Plot Schedules',
//         showProfile: false,
//         showNotification: false,
//         showThemeButton: true,
//         onBackTap: () => Navigator.of(context).pop(),
//       ),

//       body: _loadingFarmer
//           ? Center(child: CircularProgressIndicator(color: colors.primary))
//           : _localError != null
//           ? _buildMessage(
//               icon: Icons.error_outline,
//               title: 'Unable to load schedules',
//               message: _localError!,
//               onRetry: _initialize,
//             )
//           : BlocBuilder<CropBloc, CropState>(
//               bloc: _scheduleBloc,
//               builder: (context, state) {
//                 if (state.cropStatus == CropStatus.initial ||
//                     state.cropStatus == CropStatus.loading) {
//                   return Center(
//                     child: CircularProgressIndicator(color: colors.primary),
//                   );
//                 }

//                 if (state.cropStatus == CropStatus.failure) {
//                   return _buildMessage(
//                     icon: Icons.error_outline_rounded,
//                     title: 'Unable to load schedules',
//                     message: state.errorMessage ?? 'Something went wrong',
//                     onRetry: _loadSchedules,
//                   );
//                 }

//                 final schedules = state.scheduleByPlotList;

//                 if (schedules.isEmpty) {
//                   return _buildMessage(
//                     icon: Icons.event_busy_outlined,
//                     title: 'No schedules found',
//                     message: 'No crop schedules available for this plot.',
//                     onRetry: _loadSchedules,
//                   );
//                 }

//                 final totalProducts = schedules.fold<int>(
//                   0,
//                   (sum, schedule) => sum + schedule.details.length,
//                 );

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHeader(
//                             schedules.length,
//                             totalProducts,
//                             schedules.first.plotName,
//                           ),
//                           Text(
//                             'Note: Doses for 200 liters',
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.green,
//                             ),
//                           ),
//                           SizedBox(height: 6.h),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: RefreshIndicator(
//                         onRefresh: _refreshSchedules,
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           reverse: true,
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
//                           itemCount: schedules.length + 1,
//                           itemBuilder: (context, index) {
//                             if (index == schedules.length) {
//                               if (state.loadingMore) {
//                                 return const Padding(
//                                   padding: EdgeInsets.all(16),
//                                   child: Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 );
//                               }
//                               if (state.paginationError != null) {
//                                 return Column(
//                                   children: [
//                                     const Text('Unable to load more schedules'),
//                                     TextButton(
//                                       onPressed: _answerBusy
//                                           ? null
//                                           : () =>
//                                                 _loadSchedules(loadMore: true),
//                                       child: const Text('Retry'),
//                                     ),
//                                   ],
//                                 );
//                               }
//                               return const SizedBox.shrink();
//                             }
//                             final schedule = schedules[index];

//                             final id = schedule.scheduleId;

//                             return Padding(
//                               key: ValueKey(id),
//                               padding: const EdgeInsets.only(bottom: 10),
//                               child: _buildScheduleCard(
//                                 schedule,
//                                 schedule.status.trim() == '1',
//                                 (value) {
//                                   if (value) {
//                                     _confirmApplied(id);
//                                   }
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//     );
//   }

//   // ==========================================
//   // HEADER
//   // ==========================================

//   Widget _buildHeader(int count, int products, String plotName) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: colors.primaryContainer,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.event_note_outlined, color: colors.primary, size: 24),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   plotName.trim().isEmpty ? 'Plot Name' : plotName.trim(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     color: colors.onPrimaryContainer,
//                   ),
//                 ),
//                 // const SizedBox(height: 3),
//                 // Text(
//                 //   '$products recommended products',
//                 //   style: TextStyle(
//                 //     fontSize: 11,
//                 //     color: colors.onPrimaryContainer,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           Text(
//             '$count Found',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: colors.onPrimaryContainer,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // SCHEDULE CARD
//   // ==========================================

//   Widget _buildScheduleCard(
//     ScheduleByPlotEntity schedule,
//     bool selected,
//     ValueChanged<bool> onAnswer,
//   ) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: colors.outlineVariant),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             key: ValueKey(schedule.scheduleId),
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 5,
//                 children: [
//                   _miniChip(
//                     Icons.calendar_today_outlined,
//                     schedule.scheduleDate,
//                   ),
//                   _miniChip(
//                     Icons.inventory_2_outlined,
//                     '${schedule.details.length} Products',
//                   ),
//                 ],
//               ),
//               const Divider(height: 16),

//               if (schedule.adminName.isNotEmpty)
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.medical_services_outlined,
//                       size: 16,
//                       color: colors.primary,
//                     ),
//                     const SizedBox(width: 7),
//                     Expanded(
//                       child: Text(
//                         'Consultant: ${schedule.adminName}',
//                         style: TextStyle(fontSize: 11, color: colors.onSurface),
//                       ),
//                     ),
//                   ],
//                 ),

//               const SizedBox(height: 12),

//               if (schedule.details.isEmpty)
//                 const Text('No product details')
//               else
//                 _buildProductGroup(schedule, selected, onAnswer),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================
//   // GROUPED PRODUCTS
//   // ==========================================

//   Widget _buildProductGroup(
//     ScheduleByPlotEntity schedule,
//     bool selected,
//     ValueChanged<bool> onAnswer,
//   ) {
//     final colors = Theme.of(context).colorScheme;
//     final products = schedule.details;

//     return Container(
//       decoration: BoxDecoration(
//         color: colors.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: colors.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           for (int index = 0; index < products.length; index++) ...[
//             if (index > 0) Divider(height: 1, color: colors.outlineVariant),

//             _buildProductRow(index + 1, products[index]),
//           ],

//           if (schedule.remark.trim().isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text.rich(
//                   TextSpan(
//                     style: TextStyle(
//                       fontSize: 12,
//                       height: 1.5,
//                       color: colors.onPrimaryContainer,
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: 'Remark : ',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(text: schedule.remark.trim()),
//                     ],
//                   ),
//                   softWrap: true,
//                 ),
//               ),
//             ),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             color: colors.primaryContainer.withValues(alpha: 0.5),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Products applied?',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       color: colors.onSurface,
//                     ),
//                   ),
//                 ),

//                 _answerButton(
//                   'Yes',
//                   true,
//                   selected,
//                   onAnswer,
//                   isLoading: _updatingScheduleId == schedule.scheduleId,
//                 ),

//                 const SizedBox(width: 10),

//                 _answerButton('No', false, selected, onAnswer),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // PRODUCT ROW
//   // ==========================================

//   Widget _buildProductRow(int index, ScheduleDetailByPlotEntity product) {
//     final colors = Theme.of(context).colorScheme;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 22,
//                 height: 22,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: colors.primaryContainer,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   '$index',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: colors.onPrimaryContainer,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 8),

//               Expanded(
//                 child: Text(
//                   product.productName.isEmpty ? 'Product' : product.productName,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: colors.onSurface,
//                   ),
//                 ),
//               ),

//               if (product.productType.isNotEmpty)
//                 Text(
//                   product.productType,
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: colors.primary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//             ],
//           ),

//           const SizedBox(height: 8),

//           Padding(
//             padding: const EdgeInsets.only(left: 30),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _productValue(
//                     'Qty',
//                     _quantity(product.productQty, product.unit),
//                     Icons.scale_outlined,
//                   ),
//                 ),
//                 Expanded(
//                   child: _productValue(
//                     'Water',
//                     _quantity(product.waterQty, product.waterUnit),
//                     Icons.water_drop_outlined,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _productValue(String label, String value, IconData icon) {
//     final colors = Theme.of(context).colorScheme;

//     return Row(
//       children: [
//         Icon(icon, size: 14, color: colors.primary),
//         const SizedBox(width: 4),
//         Text(
//           '$label: ',
//           style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: colors.onSurface,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _quantity(String amount, String unit) {
//     if (amount.trim().isEmpty) return '-';

//     return unit.trim().isEmpty
//         ? amount.trim()
//         : '${amount.trim()} ${unit.trim()}';
//   }

//   Widget _miniChip(IconData icon, String text) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//       decoration: BoxDecoration(
//         // color: colors.primaryContainer,
//         border: Border.all(color: colors.primaryContainer),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: colors.onPrimaryContainer),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: colors.onPrimaryContainer,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // YES / NO
//   // ==========================================

//   Widget _answerButton(
//     String label,
//     bool value,
//     bool selected,
//     ValueChanged<bool> onAnswer, {
//     bool isLoading = false,
//   }) {
//     final colors = Theme.of(context).colorScheme;
//     final active = selected == value;

//     return InkWell(
//       onTap: _answerBusy || active ? null : () => onAnswer(value),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (isLoading) ...[
//             const SizedBox(
//               width: 14,
//               height: 14,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//             const SizedBox(width: 4),
//           ],
//           Icon(
//             active
//                 ? Icons.radio_button_checked_rounded
//                 : Icons.radio_button_unchecked_rounded,
//             color: active ? colors.primary : colors.onSurfaceVariant,
//             size: 19,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: active ? FontWeight.w800 : FontWeight.w500,
//               color: active ? colors.primary : colors.onSurface,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // EMPTY / ERROR
//   // ==========================================

//   Widget _buildMessage({
//     required IconData icon,
//     required String title,
//     required String message,
//     required VoidCallback onRetry,
//   }) {
//     final colors = Theme.of(context).colorScheme;

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 45, color: colors.primary),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: colors.onSurface,
//               ),
//             ),
//             const SizedBox(height: 7),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
//             ),
//             const SizedBox(height: 15),
//             FilledButton(onPressed: onRetry, child: const Text('Retry')),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CropSchedulByPlot extends StatefulWidget {
  final String plotId;

  const CropSchedulByPlot({super.key, required this.plotId});

  @override
  State<CropSchedulByPlot> createState() => _CropSchedulByPlotState();
}

class _CropSchedulByPlotState extends State<CropSchedulByPlot> {
  late final CropBloc _scheduleBloc;
  final ScrollController _scrollController = ScrollController();
  static const ValueKey<String> _todayCenterKey = ValueKey('crop-today');

  DateTime _scheduleDate(String value) {
    final raw = value.trim();
    final parts = raw.split('-');
    if (parts.length == 3 && parts[0].length <= 2) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    final parsed = DateTime.tryParse(raw);
    return parsed == null
        ? DateTime(1970)
        : DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _farmerId = '';
  String? _localError;
  bool _loadingFarmer = true;

  bool _answerBusy = false;
  String? _updatingScheduleId;
  bool _showFilters = false;
  DateTime? _from;
  DateTime? _to;
  String? _statusFilter;
  DateTime? _activeFrom;
  DateTime? _activeTo;
  String? _activeStatus;

  String _filterDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-${date.year}';

  bool get _filtersBusy =>
      _loadingFarmer ||
      _answerBusy ||
      _scheduleBloc.state.loadingMore ||
      _scheduleBloc.state.cropStatus == CropStatus.loading;

  void _openFilters() {
    if (_filtersBusy) return;
    setState(() {
      if (!_showFilters) {
        _from = _activeFrom;
        _to = _activeTo;
        _statusFilter = _activeStatus;
      }
      _showFilters = !_showFilters;
    });
  }

  Future<void> _chooseDate(bool from) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (from ? _from : _to) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (from) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  Widget _dateTile(String label, DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: _filtersBusy ? null : onTap,
      borderRadius: BorderRadius.circular(9),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 17),
        ),
        child: Text(
          value == null ? 'Select date' : _filterDate(value),
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }

  void _applyFilters({bool clear = false}) {
    if (_filtersBusy) return;
    if (!clear && _from != null && _to != null && _from!.isAfter(_to!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('From Date cannot be after To Date')),
      );
      return;
    }
    setState(() {
      if (clear) {
        _from = null;
        _to = null;
        _statusFilter = null;
      }
      _activeFrom = _from;
      _activeTo = _to;
      _activeStatus = _statusFilter;
      _showFilters = false;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    _loadSchedules();
  }

  Widget _filters() {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            key: ValueKey(_statusFilter),
            initialValue: _statusFilter ?? '',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colors.onSurface,
            ),
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: colors.onSurfaceVariant,
              ),
              floatingLabelStyle: TextStyle(
                fontSize: 12.sp,
                color: colors.primary,
              ),
              isDense: true,
              filled: true,
              fillColor: colors.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(color: colors.outlineVariant),
              ),
            ),
            items: const [
              DropdownMenuItem(value: '', child: Text('Select status')),
              DropdownMenuItem(value: '1', child: Text('Yes')),
              DropdownMenuItem(value: '0', child: Text('No')),
            ],
            onChanged: _filtersBusy
                ? null
                : (value) => setState(() {
                    _statusFilter = value == '' ? null : value;
                  }),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _dateTile('From Date', _from, () => _chooseDate(true)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateTile('To Date', _to, () => _chooseDate(false)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _filtersBusy
                      ? null
                      : () => _applyFilters(clear: true),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                  ),
                  icon: const Icon(Icons.search, size: 17),
                  label: const Text('Apply Filters'),
                  onPressed: _filtersBusy ? null : () => _applyFilters(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmApplied(String scheduleId) async {
    if (_answerBusy || _scheduleBloc.state.loadingMore) return;
    setState(() => _answerBusy = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm products applied'),
        content: const Text('Have you applied all products in this schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _answerBusy = false);
      return;
    }

    setState(() => _updatingScheduleId = scheduleId);

    // Isolate update results from list loading and pagination state.
    final updateBloc = CropBloc(
      cropScheduleUsecases: _scheduleBloc.cropScheduleUsecases,
    );
    try {
      final completion = updateBloc.stream.firstWhere(
        (state) =>
            state.cropStatus == CropStatus.success ||
            state.cropStatus == CropStatus.failure,
      );
      updateBloc.add(
        UpdateScheduleStatus(farmerId: _farmerId, scheduleId: scheduleId),
      );
      final result = await completion;
      if (!mounted) return;
      if (result.cropStatus == CropStatus.success) {
        _loadSchedules();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ??
                (result.cropStatus == CropStatus.success
                    ? 'Schedule updated successfully'
                    : 'Unable to update schedule'),
          ),
        ),
      );
    } finally {
      await updateBloc.close();
      if (mounted) {
        setState(() {
          _answerBusy = false;
          _updatingScheduleId = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scheduleBloc = CropBloc(
      cropScheduleUsecases: context.read<CropBloc>().cropScheduleUsecases,
    );
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scheduleBloc.close();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      if (widget.plotId.trim().isEmpty) {
        throw Exception('Plot ID is missing');
      }

      final farmerId = await SecureStorage.instance.getFarmerId();

      if (!mounted) return;

      if (farmerId.isEmpty || farmerId == '0') {
        throw Exception('Please login again');
      }

      setState(() {
        _farmerId = farmerId;
        _loadingFarmer = false;
        _localError = null;
      });

      _loadSchedules();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingFarmer = false;
        _localError = e.toString();
      });
    }
  }

  // Same two-edge pagination trigger as PlotScheduleHistoryPage.
  void _onScroll() {
    if (!mounted || !_scrollController.hasClients || _answerBusy) return;
    final state = _scheduleBloc.state;
    if (state.cropStatus == CropStatus.success &&
        state.hasMoreSchedules &&
        !state.loadingMore &&
        state.paginationError == null &&
        state.scheduleByPlotList.isNotEmpty &&
        (_scrollController.position.extentAfter < 300 ||
            _scrollController.position.extentBefore < 300)) {
      _loadSchedules(loadMore: true);
    }
  }

  void _checkPaginationAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = _scheduleBloc.state;
      if (_activeStatus != null &&
          _visibleSchedules(state).isEmpty &&
          state.cropStatus == CropStatus.success &&
          state.paginationError == null) {
        _loadSchedules(loadMore: true);
      } else {
        _onScroll();
      }
    });
  }

  void _loadSchedules({bool loadMore = false}) {
    final state = _scheduleBloc.state;
    if (_farmerId.isEmpty ||
        state.loadingMore ||
        state.cropStatus == CropStatus.loading ||
        (loadMore &&
            (!state.hasMoreSchedules || state.scheduleByPlotList.isEmpty))) {
      return;
    }

    _scheduleBloc.add(
      GetCropScheduleByPlotListEvent(
        _farmerId,
        widget.plotId,
        fromDate: _activeFrom == null ? '' : _filterDate(_activeFrom!),
        toDate: _activeTo == null ? '' : _filterDate(_activeTo!),
        startLimit: loadMore ? state.nextScheduleOffset.toString() : '0',
      ),
    );
  }

  Future<void> _refreshSchedules() async {
    if (_answerBusy) return;
    if (_scheduleBloc.state.loadingMore) return;
    if (_farmerId.isEmpty) {
      await _initialize();
      return;
    }

    final bloc = _scheduleBloc;

    final completion = bloc.stream.firstWhere(
      (state) =>
          state.cropStatus == CropStatus.success ||
          state.cropStatus == CropStatus.failure,
    );

    _loadSchedules();

    await completion;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: CommonDashboardAppBar(
        title: 'Plot Schedules',
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        showFilterButton: true,

        isFilterActive:
            _showFilters ||
            _activeFrom != null ||
            _activeTo != null ||
            _activeStatus != null,
        onFilterTap: _openFilters,

        onBackTap: () => Navigator.of(context).pop(),
      ),

      body: Column(
        children: [
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: _filters(),
            ),
          Expanded(
            child: _loadingFarmer
                ? Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  )
                : _localError != null
                ? _buildMessage(
                    icon: Icons.error_outline,
                    title: 'Unable to load schedules',
                    message: _localError!,
                    onRetry: _initialize,
                  )
                : BlocConsumer<CropBloc, CropState>(
                    bloc: _scheduleBloc,
                    listener: (context, state) => _checkPaginationAfterBuild(),
                    builder: (context, state) {
                      if (state.cropStatus == CropStatus.initial ||
                          state.cropStatus == CropStatus.loading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: colors.primary,
                          ),
                        );
                      }

                      if (state.cropStatus == CropStatus.failure) {
                        return _buildMessage(
                          icon: Icons.error_outline_rounded,
                          title: 'Unable to load schedules',
                          message: state.errorMessage ?? 'Something went wrong',
                          onRetry: _loadSchedules,
                        );
                      }

                      final schedules = _visibleSchedules(state);

                      if (schedules.isEmpty) {
                        if (state.loadingMore) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colors.primary,
                            ),
                          );
                        }
                        return _buildMessage(
                          icon: Icons.event_busy_outlined,
                          title: 'No schedules found',
                          message: state.loadingMore
                              ? 'Loading matching schedules...'
                              : 'No crop schedules match the selected filters.',
                          onRetry: state.paginationError != null
                              ? () => _loadSchedules(loadMore: true)
                              : _loadSchedules,
                        );
                      }

                      final totalProducts = schedules.fold<int>(
                        0,
                        (sum, schedule) => sum + schedule.details.length,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    "Note: Show Today's Schedules by default | Scroll Down ↓ → Load Future Schedules | Scroll Up ↑ → Load Past Schedules.",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      height: 1.5,
                                      color: context.primaryTextColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildHeader(
                                  schedules.length,
                                  totalProducts,
                                  schedules.first.plotName,
                                ),
                                Text(
                                  'Note: Doses for 200 liters',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _refreshSchedules,
                              child: _buildTimeline(state),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<ScheduleByPlotEntity> _visibleSchedules(CropState state) {
    return state.scheduleByPlotList
        .where(
          (schedule) =>
              _activeStatus == null || schedule.status.trim() == _activeStatus,
        )
        .toList();
  }

  // Past dates grow upward, while today and future dates grow downward.
  // The center sliver places today's position in view on first open.
  Widget _buildTimeline(CropState state) {
    final schedules = _visibleSchedules(state);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final past =
        schedules
            .where((s) => _scheduleDate(s.scheduleDate).isBefore(today))
            .toList()
          ..sort(
            (a, b) => _scheduleDate(
              b.scheduleDate,
            ).compareTo(_scheduleDate(a.scheduleDate)),
          );

    final todayAndFuture =
        schedules
            .where((s) => !_scheduleDate(s.scheduleDate).isBefore(today))
            .toList()
          ..sort(
            (a, b) => _scheduleDate(
              a.scheduleDate,
            ).compareTo(_scheduleDate(b.scheduleDate)),
          );

    Widget scheduleCard(ScheduleByPlotEntity schedule) {
      final id = schedule.scheduleId;
      return Padding(
        key: ValueKey(id),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        child: _buildScheduleCard(schedule, schedule.status.trim() == '1', (
          value,
        ) {
          if (value) _confirmApplied(id);
        }),
      );
    }

    Widget paginationIndicator() {
      if (state.loadingMore) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (state.paginationError != null) {
        return Center(
          child: TextButton(
            onPressed: _answerBusy
                ? null
                : () => _loadSchedules(loadMore: true),
            child: const Text('Unable to load more schedules. Tap to retry'),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    // A single card should start below the header regardless of its date.
    if (schedules.length == 1) {
      return ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [scheduleCard(schedules.single), paginationIndicator()],
      );
    }

    // Without current or future entries, an empty center sliver would put
    // all available cards above the initial viewport. Open at the latest
    // past schedule instead, with older history growing upward.
    if (todayAndFuture.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: past.length + 1,
          itemBuilder: (context, index) {
            if (index == past.length) return paginationIndicator();
            return scheduleCard(past[index]);
          },
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      center: _todayCenterKey,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: paginationIndicator()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => scheduleCard(past[index]),
            childCount: past.length,
          ),
        ),
        SliverToBoxAdapter(
          key: _todayCenterKey,
          child: const SizedBox.shrink(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => scheduleCard(todayAndFuture[index]),
            childCount: todayAndFuture.length,
          ),
        ),
        SliverToBoxAdapter(child: paginationIndicator()),
      ],
    );
  }

  // ==========================================
  // HEADER
  // ==========================================

  Widget _buildHeader(int count, int products, String plotName) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.event_note_outlined, color: colors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plotName.trim().isEmpty ? 'Plot Name' : plotName.trim(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                // const SizedBox(height: 3),
                // Text(
                //   '$products recommended products',
                //   style: TextStyle(
                //     fontSize: 11,
                //     color: colors.onPrimaryContainer,
                //   ),
                // ),
              ],
            ),
          ),
          Text(
            '$count Found',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SCHEDULE CARD
  // ==========================================

  Widget _buildScheduleCard(
    ScheduleByPlotEntity schedule,
    bool selected,
    ValueChanged<bool> onAnswer,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: selected
            ? Color.alphaBlend(
                colors.primary.withValues(alpha: 0.08),
                colors.surface,
              )
            : colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            key: ValueKey(schedule.scheduleId),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 5,
                children: [
                  _miniChip(
                    Icons.calendar_today_outlined,
                    schedule.scheduleDate,
                  ),
                  _miniChip(
                    Icons.inventory_2_outlined,
                    '${schedule.details.length} Products',
                  ),
                ],
              ),
              const Divider(height: 16),

              if (schedule.adminName.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 16,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Consultant: ${schedule.adminName}',
                        style: TextStyle(fontSize: 11, color: colors.onSurface),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              if (schedule.details.isEmpty)
                const Text('No product details')
              else
                _buildProductGroup(schedule, selected, onAnswer),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // GROUPED PRODUCTS
  // ==========================================

  Widget _buildProductGroup(
    ScheduleByPlotEntity schedule,
    bool selected,
    ValueChanged<bool> onAnswer,
  ) {
    final colors = Theme.of(context).colorScheme;
    final products = schedule.details;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          for (int index = 0; index < products.length; index++) ...[
            if (index > 0) Divider(height: 1, color: colors.outlineVariant),

            _buildProductRow(index + 1, products[index]),
          ],

          if (schedule.remark.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: colors.onPrimaryContainer,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Remark : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: schedule.remark.trim()),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: colors.primaryContainer.withValues(alpha: 0.5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Products applied?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                _answerButton(
                  'Yes',
                  true,
                  selected,
                  onAnswer,
                  isLoading: _updatingScheduleId == schedule.scheduleId,
                ),

                const SizedBox(width: 10),

                _answerButton('No', false, selected, onAnswer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PRODUCT ROW
  // ==========================================

  Widget _buildProductRow(int index, ScheduleDetailByPlotEntity product) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  product.productName.isEmpty ? 'Product' : product.productName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ),

              if (product.productType.isNotEmpty)
                Text(
                  product.productType,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Expanded(
                  child: _productValue(
                    'Qty',
                    _quantity(product.productQty, product.unit),
                    Icons.scale_outlined,
                  ),
                ),
                Expanded(
                  child: _productValue(
                    'Water',
                    _quantity(product.waterQty, product.waterUnit),
                    Icons.water_drop_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productValue(String label, String value, IconData icon) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colors.primary),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  String _quantity(String amount, String unit) {
    if (amount.trim().isEmpty) return '-';

    return unit.trim().isEmpty
        ? amount.trim()
        : '${amount.trim()} ${unit.trim()}';
  }

  Widget _miniChip(IconData icon, String text) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        // color: colors.primaryContainer,
        border: Border.all(color: colors.primaryContainer),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // YES / NO
  // ==========================================

  Widget _answerButton(
    String label,
    bool value,
    bool selected,
    ValueChanged<bool> onAnswer, {
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    final active = selected == value;

    return InkWell(
      onTap: _answerBusy || active ? null : () => onAnswer(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 4),
          ],
          Icon(
            active
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: active ? colors.primary : colors.onSurfaceVariant,
            size: 19,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              color: active ? colors.primary : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY / ERROR
  // ==========================================

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 45, color: colors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 15),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
