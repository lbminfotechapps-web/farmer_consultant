import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorage {
  SecureStorage._();

  static final SecureStorage instance = SecureStorage._();

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  static const String userKey = 'user_data';

  // Save only the result object from login response
  Future<void> saveUserData(Map<String, dynamic> data) async {
    await _storage.write(
      key: userKey,
      value: jsonEncode(data),
    );
  }

  // Get complete saved farmer data
  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: userKey);

    if (data == null || data.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(data);

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    return null;
  }

  // Get only farmer ID
  Future<String> getFarmerId() async {
    final userData = await getUserData();

    return userData?['fld_farmer_id']?.toString() ?? '';
  }

  // Get farmer name
  Future<String> getFarmerName() async {
    final userData = await getUserData();

    return userData?['fld_farmer_name']?.toString() ?? '';
  }

  // Get farmer mobile number
  Future<String> getFarmerMobileNo() async {
    final userData = await getUserData();

    return userData?['fld_mobile_no']?.toString() ?? '';
  }

  // Get farmer address
  Future<String> getFarmerAddress() async {
    final userData = await getUserData();

    return userData?['fld_address']?.toString() ?? '';
  }

  // Check login status
  Future<bool> isLoggedIn() async {
    final farmerId = await getFarmerId();

    return farmerId.isNotEmpty && farmerId != '0';
  }

  // Logout: remove stored user data
  Future<void> clearUserData() async {
    await _storage.delete(key: userKey);
  }
}

