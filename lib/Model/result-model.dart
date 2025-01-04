
class ResultModel {
  final String sNumber;
  final String result;
  final int status;
  final String message;
  final String jokerStatus;

  ResultModel({
    required this.sNumber,
    required this.result,
    required this.status,
    required this.message,
    required this.jokerStatus,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      sNumber: json['s_number'],
      result: json['result'],
      status: json['status'],
      message: json['message'],
      jokerStatus: json['joker_status'],
    );
  }
}