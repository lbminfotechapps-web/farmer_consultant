
import 'package:farmer_consultant/features/report/domain/entity/organization.dart';


abstract class OrganizationRepository {
  Future<Organization> getOrganizationDetails();


}