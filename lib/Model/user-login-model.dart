class UserModel {
  final String id;
  final String username;
  final String email;
  final String mobile;
  final String roleId;
  final String parentId;
  final String status;
  final String datetime;
  final String wallet;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.roleId,
    required this.parentId,
    required this.status,
    required this.datetime,
    required this.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      mobile: json['mobile'] ?? "",
      roleId: json['role_id'] ?? "",
      parentId: json['parentid'] ?? "",
      status: json['status'] ?? "",
      datetime: json['datetime'] ?? "",
      wallet: json['wallet']??'',
    );
  }
}
