import 'dart:convert';
import 'package:funroullete_new/Constant/url.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<Map<String, dynamic>> getProfile(String userId) async {

    try {
      final response = await http.get(Uri.parse(AppUrls.profileViewApiUrl+userId));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
