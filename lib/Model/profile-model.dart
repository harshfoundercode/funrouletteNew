class Profile {
  final String id;
  final String? type;
  final String username;
  final String email;
  final String password;
  final String mobile;
  final String roleId;
  final String wallet;
  final String? commission;
  final String commissionAmount;
  final String bonus;
  final String winning;
  final String parentId;
  final String? referralCode;
  final String status;
  final String datetime;

  Profile({
    required this.id,
    required this.type,
    required this.username,
    required this.email,
    required this.password,
    required this.mobile,
    required this.roleId,
    required this.wallet,
    required this.commission,
    required this.commissionAmount,
    required this.bonus,
    required this.winning,
    required this.parentId,
    required this.referralCode,
    required this.status,
    required this.datetime,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? "",
      type: json['type'],
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      mobile: json['mobile'] ?? "",
      roleId: json['role_id'] ?? "",
      wallet: json['wallet'] ?? "",
      commission: json['commission'],
      commissionAmount: json['commission_amount'] ?? "",
      bonus: json['bonus'] ?? "",
      winning: json['winning'] ?? "",
      parentId: json['parentid'] ?? "",
      referralCode: json['referral_code'],
      status: json['status'] ?? "",
      datetime: json['datetime'] ?? "",
    );
  }
}
