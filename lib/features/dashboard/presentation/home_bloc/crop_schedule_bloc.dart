import 'dart:async';
import 'dart:convert';

import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_usecases/get_crop_schedules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'crop_schedule_event.dart';
import 'crop_schedule_state.dart';

class CropScheduleBloc extends Bloc<CropScheduleEvent, CropScheduleState> {
  final GetCropSchedules getCropSchedules;

  CropScheduleBloc({required this.getCropSchedules})
    : super(const CropScheduleState()) {
    on<GetCropSchedulesEvent>(_onGetCropSchedules);

    on<RefreshCropSchedulesEvent>(_onRefreshCropSchedules);
    on<FarmerSuccessStoryEvent>(_onFarmerSuccessStory);
    on<UpdateNotificationStatusEvent>(_onUpdateNotificationStatus);
  }

  // =========================================================
  // GET CROP SCHEDULE
  // =========================================================

  Future<void> _onGetCropSchedules(
    GetCropSchedulesEvent event,
    Emitter<CropScheduleState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CropScheduleStatus.loading,
        schedules: [],
        clearErrorMessage: true,
      ),
    );

    try {
      final schedules = await getCropSchedules();

      emit(
        state.copyWith(
          status: CropScheduleStatus.success,
          schedules: schedules,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<void> _onRefreshCropSchedules(
    RefreshCropSchedulesEvent event,
    Emitter<CropScheduleState> emit,
  ) async {
    try {
      final schedules = await getCropSchedules();

      emit(
        state.copyWith(
          status: CropScheduleStatus.success,
          schedules: schedules,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      // Keep old data during refresh failure
      emit(
        state.copyWith(
          status: CropScheduleStatus.success,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFarmerSuccessStory(
    FarmerSuccessStoryEvent event,
    Emitter<CropScheduleState> emit,
  ) async {
    // STEP 1: Prevent duplicate API requests.
    if (state.status == CropScheduleStatus.loading) {
      return;
    }

    // STEP 2: Validate required parameters.
    if (event.farmerId.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: 'Farmer ID is required',
        ),
      );
      return;
    }

    // STEP 3: Validate startLimit.
    final int? startLimit = int.tryParse(event.startLimit.trim());

    if (startLimit == null || startLimit < 0) {
      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: 'Invalid start limit',
        ),
      );
      return;
    }

    // STEP 4: Set loading status.
    emit(state.copyWith(status: CropScheduleStatus.loading, errorMessage: ''));

    try {
      debugPrint('========== GET SUCCESS STORY LIST ==========');
      debugPrint('Farmer ID: ${event.farmerId}');
      debugPrint('From Date: ${event.fromDate}');
      debugPrint('To Date: ${event.toDate}');
      debugPrint('Start Limit: ${event.startLimit}');

      // STEP 5: Call UseCase.
      final SuccessStoryEntity response = await getCropSchedules
          .getSuccessStoryList(
            event.farmerId.trim(),
            event.fromDate.trim(),
            event.toDate.trim(),
            event.startLimit.trim(),
          );

      debugPrint('========== SUCCESS STORY RESPONSE ==========');
      debugPrint('Status: ${response.status}');
      debugPrint('Message: ${response.message}');
      debugPrint('Total Records: ${response.result.length}');

      // STEP 6: Handle API failure.
      if (!response.status) {
        emit(
          state.copyWith(
            status: CropScheduleStatus.failure,
            errorMessage: response.message.isNotEmpty
                ? response.message
                : 'Unable to fetch success stories',
          ),
        );
        return;
      }

      // STEP 7: Handle success.
      emit(
        state.copyWith(
          status: CropScheduleStatus.success,
          successStoryEntity: response,
          errorMessage: '',
        ),
      );

      debugPrint(
        'Success Story List Fetched Successfully: '
        '${response.result.length} records',
      );
    } catch (e, stackTrace) {
      debugPrint('Get Success Story List Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateNotificationStatus(
    UpdateNotificationStatusEvent event,
    Emitter<CropScheduleState> emit,
  ) async {
    // STEP 1: Prevent duplicate API requests.
    if (state.status == CropScheduleStatus.loading) {
      return;
    }

    // STEP 2: Validate Farmer ID.
    if (event.farmerId.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: 'Farmer ID is required',
        ),
      );
      return;
    }

    // STEP 3: Set loading state.
    emit(state.copyWith(status: CropScheduleStatus.loading, errorMessage: ''));

    try {
      debugPrint('========== UPDATE NOTIFICATION STATUS ==========');
      debugPrint('Farmer ID: ${event.farmerId}');

      // STEP 4: Call UseCase.
      final response = await getCropSchedules.updateNotificationStatus(
        event.farmerId.trim(),
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      // STEP 5: Parse API response.
      final dynamic decodedData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decodedData is! Map) {
        throw const FormatException(
          'Invalid update notification status response',
        );
      }

      final data = Map<String, dynamic>.from(decodedData);

      final bool success =
          data['status'] == true ||
          data['status'] == 1 ||
          data['status']?.toString().toLowerCase() == 'true';

      final String message = data['message']?.toString().trim() ?? '';

      // STEP 6: Handle API failure.
      if (!success) {
        emit(
          state.copyWith(
            status: CropScheduleStatus.failure,
            errorMessage: message.isNotEmpty
                ? message
                : 'Unable to update notification status',
          ),
        );
        return;
      }

      // STEP 7: Handle API success.
      emit(
        state.copyWith(
          status: CropScheduleStatus.success,
          errorMessage: message.isNotEmpty
              ? message
              : 'Notification status updated successfully',
        ),
      );

      debugPrint('Notification Status Updated Successfully');
    } catch (e, stackTrace) {
      debugPrint('Update Notification Status Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          status: CropScheduleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
