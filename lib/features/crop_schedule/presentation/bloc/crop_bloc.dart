import 'dart:async';
import 'dart:convert';

import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_finance_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class CropBloc extends Bloc<CropEvent, CropState> {
  final CropScheduleUsecases cropScheduleUsecases;

  CropBloc({required this.cropScheduleUsecases}) : super(const CropState()) {
    on<GetCropScheduleEvent>(_onGetCropSchedule);
    on<GetPlotListEvent>(_onGetPlotList);
    on<GetCropScheduleByPlotListEvent>(_onGetCropScheduleByPlot);
    on<UpdateScheduleStatus>(_onUpdateScheduleStatus);
    on<GetAvailableDatesEvent>(_onGetAvailableDates);
    on<AddPlotFinanceEvent>(_onAddPlotFinance);
    on<GetPlotFinanceEvent>(_onGetPlotFinance);
    on<DeletePlotFinanceEvent>(_onDeletePlotFinance);
  }

  Future<void> _onDeletePlotFinance(
    DeletePlotFinanceEvent event,
    Emitter<CropState> emit,
  ) async {
    if (state.cropStatus == CropStatus.loading) return;
    emit(state.copyWith(cropStatus: CropStatus.loading, clearError: true));
    try {
      if (event.financeId.trim().isEmpty || event.farmerId.trim().isEmpty) {
        throw const FormatException('Finance ID and Farmer ID are required');
      }
      final response = await cropScheduleUsecases.deletePlotFinance(
        event.financeId.trim(),
        event.farmerId.trim(),
      );
      final dynamic data = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      if (data is! Map) {
        throw const FormatException('Invalid delete plot finance response');
      }
      final success =
          data['status'] == true ||
          data['status'] == 1 ||
          data['status']?.toString().toLowerCase() == 'true';
      final message = data['message']?.toString().trim() ?? '';
      emit(
        state.copyWith(
          cropStatus: success ? CropStatus.success : CropStatus.failure,
          errorMessage: message.isNotEmpty
              ? message
              : success
              ? 'Plot finance deleted successfully'
              : 'Unable to delete plot finance',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onGetCropSchedule(
    GetCropScheduleEvent event,
    Emitter<CropState> emit,
  ) async {
    // Step 1: Loading state
    emit(
      state.copyWith(
        cropStatus: CropStatus.loading,
        clearError: true,
        sceduleentityList: [],
      ),
    );

    try {
      final farmerId = event.farmerId.trim();
      if (farmerId.isEmpty) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: 'Farmer ID is required to load crop schedules.',
          ),
        );
        return;
      }
      debugPrint('========== GET CROP SCHEDULE ==========');
      debugPrint('farmerId: ${event.farmerId}');
      debugPrint('fromDate: ${event.fromDate}');
      debugPrint('toDate: ${event.toDate}');

      // Step 2: Call UseCase
      final ScheduleResponseEntity response = await cropScheduleUsecases
          .getFarmerScheduleList(
            farmerId,
            event.fromDate ?? '',
            event.toDate ?? '',
          );

      debugPrint('Schedule status: ${response.status}');
      debugPrint('Schedule message: ${response.message}');
      debugPrint('Schedule count: ${response.result.length}');

      // Step 3: Handle unsuccessful API response
      if (!response.status) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: response.message.isNotEmpty
                ? response.message
                : 'Unable to fetch crop schedules',
            sceduleentityList: [],
          ),
        );
        return;
      }

      // Step 4: Success state
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          sceduleentityList: response.result,
          clearError: true,
        ),
      );

      debugPrint('Crop schedules loaded successfully');
    } catch (e, stackTrace) {
      debugPrint('Crop schedule API error: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Step 5: Error state
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: e.toString(),
          sceduleentityList: [],
        ),
      );
    }
  }

  Future<void> _onGetPlotList(
    GetPlotListEvent event,
    Emitter<CropState> emit,
  ) async {
    if (state.loadingMorePlots || state.cropStatus == CropStatus.loading) {
      return;
    }
    final offset = int.tryParse(event.startLimit ?? '0') ?? 0;
    final append = offset > 0;
    if (append && !state.hasMorePlots) return;
    emit(
      state.copyWith(
        cropStatus: append ? CropStatus.success : CropStatus.loading,
        loadingMorePlots: append,
        clearError: true,
        clearPlotPaginationError: true,
        plotLits: append ? null : [],
        nextPlotOffset: append ? null : 0,
        hasMorePlots: append ? null : true,
      ),
    );
    try {
      final response = await cropScheduleUsecases.getPlotList(
        event.farmerId,
        event.plotName ?? '',
        event.cropId ?? '',
        offset.toString(),
      );
      if (!response.status) {
        throw Exception(
          response.message.isNotEmpty
              ? response.message
              : 'Unable to fetch plots',
        );
      }
      final existing = append ? state.plotLits : <PlotEntity>[];
      final ids = existing.map((plot) => plot.plotRegistrationId).toSet();
      final additions = response.result
          .where(
            (plot) =>
                plot.plotRegistrationId.isEmpty ||
                ids.add(plot.plotRegistrationId),
          )
          .toList();
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          loadingMorePlots: false,
          plotLits: [...existing, ...additions],
          nextPlotOffset: offset + 15,
          // The response has no total/has-more field. A short page alone
          // cannot establish that the server has no remaining plots.
          hasMorePlots: additions.isNotEmpty,
          clearError: true,
          clearPlotPaginationError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          cropStatus: append ? CropStatus.success : CropStatus.failure,
          loadingMorePlots: false,
          errorMessage: append ? null : error.toString(),
          plotPaginationError: append ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> _onGetCropScheduleByPlot(
    GetCropScheduleByPlotListEvent event,
    Emitter<CropState> emit,
  ) async {
    if (state.loadingMore || state.cropStatus == CropStatus.loading) return;
    final offset = int.tryParse(event.startLimit ?? '0') ?? 0;
    final append = offset > 0;
    if (append && !state.hasMoreSchedules) return;

    emit(
      state.copyWith(
        cropStatus: append ? CropStatus.success : CropStatus.loading,
        loadingMore: append,
        clearError: true,
        scheduleByPlotList: append ? null : [],
        nextScheduleOffset: append ? null : 0,
        hasMoreSchedules: append ? null : true,
      ),
    );

    try {
      final response = await cropScheduleUsecases.getScheduleListByPlot(
        event.farmerId,
        event.plotId,
        event.cropId ?? '',
        event.fromDate ?? '',
        event.toDate ?? '',
        offset.toString(),
      );
      if (!response.status) {
        throw Exception(
          response.message.isNotEmpty
              ? response.message
              : 'Unable to load schedules',
        );
      }
      final existing = append
          ? state.scheduleByPlotList
          : <ScheduleByPlotEntity>[];
      final ids = existing.map((schedule) => schedule.scheduleId).toSet();
      final additions = response.result
          .where(
            (schedule) =>
                schedule.scheduleId.isEmpty || ids.add(schedule.scheduleId),
          )
          .toList();
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          loadingMore: false,
          scheduleByPlotList: [...existing, ...additions],
          nextScheduleOffset: offset + 10,
          hasMoreSchedules:
              response.result.length >= 10 && additions.isNotEmpty,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          cropStatus: append ? CropStatus.success : CropStatus.failure,
          loadingMore: false,
          errorMessage: append ? null : error.toString(),
          paginationError: append ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> _onUpdateScheduleStatus(
    UpdateScheduleStatus event,
    Emitter<CropState> emit,
  ) async {
    // Prevent duplicate submissions while updating.
    if (state.cropStatus == CropStatus.loading) {
      return;
    }

    if (event.scheduleId.trim().isEmpty || event.farmerId.trim().isEmpty) {
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: 'Schedule ID and Farmer ID are required',
        ),
      );
      return;
    }

    try {
      debugPrint('========== UPDATE SCHEDULE STATUS ==========');
      debugPrint('Schedule ID: ${event.scheduleId}');
      debugPrint('Farmer ID: ${event.farmerId}');

      // STEP 2: Call UseCase
      final response = await cropScheduleUsecases.updateScheduleStatus(
        event.scheduleId,
        event.farmerId,
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      // STEP 3: Parse API response
      final dynamic decodedData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decodedData is! Map) {
        throw const FormatException('Invalid update schedule response');
      }

      final data = Map<String, dynamic>.from(decodedData);

      final bool success =
          data['status'] == true ||
          data['status']?.toString().toLowerCase() == 'true';

      final String message = data['message']?.toString() ?? '';

      // STEP 4: Handle API failure
      if (!success) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: message.isNotEmpty
                ? message
                : 'Unable to update schedule status',
          ),
        );
        return;
      }

      // STEP 5: Success
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          errorMessage: message.isNotEmpty
              ? message
              : 'Schedule status updated successfully',
        ),
      );

      debugPrint('Schedule Status Updated Successfully');
    } catch (e, stackTrace) {
      debugPrint('Update Schedule Status Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onGetAvailableDates(
    GetAvailableDatesEvent event,
    Emitter<CropState> emit,
  ) async {
    emit(
      state.copyWith(
        cropStatus: CropStatus.loading,
        clearError: true,
        availableDateList: [],
      ),
    );

    try {
      final farmerId = event.farmerId.trim();

      if (farmerId.isEmpty) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: 'Farmer ID is required to load Available Dates.',
          ),
        );
        return;
      }

      debugPrint('========== GET AVAILABLE DATES ==========');
      debugPrint('farmerId: $farmerId');

      final AvailableDatesEntity response = await cropScheduleUsecases
          .getAvailableDates(farmerId);

      debugPrint('Date status: ${response.status}');
      debugPrint('Date message: ${response.message}');
      debugPrint('Date count: ${response.result.length}');

      if (!response.status) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: response.message.isNotEmpty
                ? response.message
                : 'Unable to fetch dates',
            availableDateList: [],
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          availableDateList: response.result,
          clearError: true,
        ),
      );

      debugPrint('Available dates loaded successfully: ${response.result}');
    } catch (e, stackTrace) {
      debugPrint('Available dates API error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: e.toString(),
          availableDateList: [],
        ),
      );
    }
  }

  Future<void> _onAddPlotFinance(
    AddPlotFinanceEvent event,
    Emitter<CropState> emit,
  ) async {
    debugPrint('AddPlotFinanceEvent received');
    // STEP 1: Prevent duplicate submissions.
    if (state.cropStatus == CropStatus.loading) {
      return;
    }

    // STEP 2: Validate required parameters.
    if (event.date.trim().isEmpty ||
        event.amount.trim().isEmpty ||
        event.farmerId.trim().isEmpty ||
        event.plotId.trim().isEmpty ||
        event.type.trim().isEmpty) {
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: 'Please fill all required fields',
        ),
      );
      return;
    }

    final double? amount = double.tryParse(event.amount.trim());

    if (amount == null || !amount.isFinite || amount <= 0) {
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: 'Please enter a valid amount',
        ),
      );
      return;
    }

    // STEP 3: Set loading state.
    emit(state.copyWith(cropStatus: CropStatus.loading, errorMessage: ''));

    try {
      debugPrint('========== ADD PLOT FINANCE ==========');
      debugPrint('Date: ${event.date}');
      debugPrint('Amount: ${event.amount}');
      debugPrint('Remark: ${event.remark}');
      debugPrint('Farmer ID: ${event.farmerId}');
      debugPrint('Plot ID: ${event.plotId}');
      debugPrint('Type: ${event.type}');

      // STEP 4: Call UseCase.
      final response = await cropScheduleUsecases.addPlotFinance(
        event.date,
        event.amount,
        event.remark,
        event.farmerId,
        event.plotId,
        event.type,
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      // STEP 5: Parse API response.
      final dynamic decodedData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decodedData is! Map) {
        throw const FormatException('Invalid add plot finance response');
      }

      final data = Map<String, dynamic>.from(decodedData);

      final bool success =
          data['status'] == true ||
          data['status'] == 1 ||
          data['status']?.toString().toLowerCase() == 'true';

      final String message = data['message']?.toString() ?? '';

      // STEP 6: Handle API failure.
      if (!success) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: message.isNotEmpty
                ? message
                : 'Unable to add plot finance',
          ),
        );
        return;
      }

      // STEP 7: Handle success.
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          errorMessage: message.isNotEmpty
              ? message
              : 'Plot finance added successfully',
        ),
      );

      debugPrint('Plot Finance Added Successfully');
    } catch (e, stackTrace) {
      debugPrint('Add Plot Finance Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetPlotFinance(
    GetPlotFinanceEvent event,
    Emitter<CropState> emit,
  ) async {
    // STEP 1: Prevent duplicate requests.
    if (state.cropStatus == CropStatus.loading) {
      return;
    }

    // STEP 2: Validate parameters.
    if (event.farmerId.trim().isEmpty || event.plotId.trim().isEmpty) {
      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: 'Farmer ID and Plot ID are required',
        ),
      );
      return;
    }

    // STEP 3: Set loading state.
    emit(state.copyWith(cropStatus: CropStatus.loading, errorMessage: ''));

    try {
      debugPrint('========== GET PLOT FINANCE ==========');
      debugPrint('Farmer ID: ${event.farmerId}');
      debugPrint('Plot ID: ${event.plotId}');
      debugPrint('Type: ${event.type}');

      // STEP 4: Call UseCase.
      final PlotFinanceEntity response = await cropScheduleUsecases
          .getPlotFinance(
            event.farmerId.trim(),
            event.plotId.trim(),
            event.type.trim(),
          );

      debugPrint('========== PLOT FINANCE RESPONSE ==========');
      debugPrint('Status: ${response.status}');
      debugPrint('Message: ${response.message}');
      debugPrint('Total Income: ${response.totalIncome}');
      debugPrint('Total Expense: ${response.totalExpense}');
      debugPrint('Profit: ${response.profit}');
      debugPrint('Total Records: ${response.result.length}');

      // STEP 5: Handle API failure.
      if (!response.status) {
        emit(
          state.copyWith(
            cropStatus: CropStatus.failure,
            errorMessage: response.message.isNotEmpty
                ? response.message
                : 'Unable to fetch plot finance details',
          ),
        );
        return;
      }

      // STEP 6: Handle API success.
      emit(
        state.copyWith(
          cropStatus: CropStatus.success,
          plotFinanceEntity: response,
          errorMessage: response.message.isNotEmpty
              ? response.message
              : 'Plot finance details fetched successfully',
        ),
      );

      debugPrint('Plot Finance Fetched Successfully');
    } catch (e, stackTrace) {
      debugPrint('Get Plot Finance Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          cropStatus: CropStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
