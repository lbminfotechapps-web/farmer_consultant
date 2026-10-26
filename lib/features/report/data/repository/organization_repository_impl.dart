

import 'package:farmer_consultant/features/report/data/datasource/organization_remote_data_source.dart';
import 'package:farmer_consultant/features/report/domain/entity/organization.dart';
import 'package:farmer_consultant/features/report/domain/repositories/organization_repository.dart';

class OrganizationRepositoryImpl
    implements OrganizationRepository {

  final OrganizationRemoteDataSource remoteDataSource;

  OrganizationRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Organization> getOrganizationDetails() async {
    return await remoteDataSource
        .getOrganizationDetails();
  }





}