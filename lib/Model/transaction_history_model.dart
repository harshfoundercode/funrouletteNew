class TransactionHistoryModel {
  String? id;
  String? userid;
  String? type;
  String? amount;
  String? status;
  String? orderid;
  String? datetime;

  TransactionHistoryModel(
      {this.id,
        this.userid,
        this.type,
        this.amount,
        this.status,
        this.orderid,
        this.datetime});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    type = json['type'];
    amount = json['amount'];
    status = json['status'];
    orderid = json['orderid'];
    datetime = json['datetime'];
  }
}
