import 'package:farmer_consultant/features/quickchartreport/domain/usecases/galleryusecase.dart';
import 'package:farmer_consultant/features/quickchartreport/presentation/bloc/galleryevent.dart';
import 'package:farmer_consultant/features/quickchartreport/presentation/bloc/gallerystate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetGallery getGallery;

  GalleryBloc({required this.getGallery}) : super(const GalleryState()) {
    on<GetGalleryEvent>(_onGetGallery);
  }

  Future<void> _onGetGallery(
    GetGalleryEvent event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: GalleryStatus.loading, message: ''));

    try {
      final result = await getGallery();

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          galleryList: result,
          message: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GalleryStatus.failure, message: e.toString()),
      );
    }
  }
}
