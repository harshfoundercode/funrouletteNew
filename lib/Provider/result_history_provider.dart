import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:http/http.dart' as http;
import '../Model/result-history-model.dart';

class ResultHistoryProvider extends ChangeNotifier {
  ResultHistoryModel? _result;

  ResultHistoryModel? get result => _result;

  Future<void> fetchResulthistoryData(context) async {
    final response = await http.get(Uri.parse(AppUrls.resultHistoryApiUrl));

    if (response.statusCode == 200) {
      print(response.body);
      final responseData = json.decode(response.body);
      if(responseData['status']==200){
        final Map<String, dynamic> data = responseData;
        print(data);
        _result = ResultHistoryModel.fromJson(data);
      }
      else{
        Utils.errorToastMessage(responseData['message'],context);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
