import 'package:flutter/material.dart';
import 'package:funroullete_new/Model/profile-model.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/api/profile-service.dart';

import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;
  String _errorMessage = "";

  Profile? get profile => _profile;
  String get errorMessage => _errorMessage;

  final ProfileService _profileService = ProfileService();

  Future<void> fetchProfile(context) async {
    final user_id = Provider.of<UserProvider>(context,listen: false).user!.id;
    try {
      final response = await _profileService.getProfile(user_id);
      _profile = Profile.fromJson(response['data']);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to load profile: $e";
      notifyListeners();
    }
  }
}
