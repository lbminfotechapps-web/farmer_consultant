import 'package:farmer_consultant/features/important_links/domain/usecases/%20get_important_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'important_links_event.dart';
import 'important_links_state.dart';

class ImportantLinksBloc
    extends Bloc<ImportantLinksEvent, ImportantLinksState> {
  final GetImportantLinks getImportantLinks;

  ImportantLinksBloc({required this.getImportantLinks})
    : super(ImportantLinksInitial()) {
    on<FetchImportantLinks>(_onFetchImportantLinks);
  }

  Future<void> _onFetchImportantLinks(
    FetchImportantLinks event,
    Emitter<ImportantLinksState> emit,
  ) async {
    emit(ImportantLinksLoading());

    try {
      final links = await getImportantLinks();

      emit(ImportantLinksLoaded(links));
    } catch (e) {
      emit(ImportantLinksError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
