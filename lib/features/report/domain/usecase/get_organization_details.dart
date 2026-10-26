import 'package:farmer_consultant/features/report/domain/entity/organization.dart';

import '../repositories/organization_repository.dart';

class GetOrganizationDetails {
  final OrganizationRepository repository;

  GetOrganizationDetails({required this.repository});

  Future<Organization> call() async {
    return await repository.getOrganizationDetails();
  }

}
