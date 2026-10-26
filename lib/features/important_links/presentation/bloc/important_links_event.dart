import 'package:equatable/equatable.dart';

abstract class ImportantLinksEvent extends Equatable {
  const ImportantLinksEvent();

  @override
  List<Object?> get props => [];
}

class FetchImportantLinks extends ImportantLinksEvent {
  const FetchImportantLinks();
}
