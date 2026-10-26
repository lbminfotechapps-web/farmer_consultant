import 'package:equatable/equatable.dart';

import '../../domain/entities/important_link_entity.dart';

abstract class ImportantLinksState extends Equatable {
  const ImportantLinksState();

  @override
  List<Object?> get props => [];
}

class ImportantLinksInitial extends ImportantLinksState {}

class ImportantLinksLoading extends ImportantLinksState {}

class ImportantLinksLoaded extends ImportantLinksState {
  final List<ImportantLinkEntity> links;

  const ImportantLinksLoaded(this.links);

  @override
  List<Object?> get props => [links];
}

class ImportantLinksError extends ImportantLinksState {
  final String message;

  const ImportantLinksError(this.message);

  @override
  List<Object?> get props => [message];
}
