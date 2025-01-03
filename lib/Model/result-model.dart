
class ResultModel {
  final String sNumber;
  final String result;
  final int status;
  final String message;

  ResultModel({
    required this.sNumber,
    required this.result,
    required this.status,
    required this.message,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      sNumber: json['s_number'],
      result: json['result'],
      status: json['status'],
      message: json['message'],
    );
  }
}