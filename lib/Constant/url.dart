// ignore_for_file: constant_identifier_names

class AppUrls {
  // Base Url....
  // static const BaseUrl = "https://funtarget.fctechteam.org/";
  // static const BaseUrl = "https://funtarget.live/";
  static const BaseUrl = "https://funroulette.funtarget.live/";

  static const loginApiUrl = "${BaseUrl}user_login";
  static const insertBetApiUrl = "${BaseUrl}bets";
  static const resultHistoryApiUrl = "${BaseUrl}result_history";
  static const resultApiUrl = "${BaseUrl}result";
  static const profileViewApiUrl = "${BaseUrl}profile?userid=";
  static const insertWinningAmount = "${BaseUrl}winging_amount";
  static const addacount = "${BaseUrl}addAccount";
  static const payin = "${BaseUrl}user_payin";
  static const viewAccount = "${BaseUrl}account_view?userid=";
  static const withdraw = "${BaseUrl}withdraw";
  static const transactionHistory = "${BaseUrl}transaction_history?userid=";
}
