import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Views/view2/add_account.dart';
import 'package:funroullete_new/Views/view2/deposit_screen.dart';
import 'package:funroullete_new/Views/view2/view_account_screen.dart';
import 'package:funroullete_new/Views/view2/withdraw_screen.dart';
import 'package:funroullete_new/main.dart';

class SettingScreen2 extends StatefulWidget {
  const SettingScreen2({super.key});

  @override
  State<SettingScreen2> createState() => _SettingScreen2State();
}

class _SettingScreen2State extends State<SettingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width * 0.55,
          height: height * 0.70,
          decoration: BoxDecoration(
            color: Colors.brown.shade900,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  color: ColorConstant.whiteColor,
                  height: height * 0.01,
                ),
                const SizedBox(height: 20),
                _buildOption(
                    context,
                    title: "Add Account",
                    icon: Icons.person_add_alt, onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AddAccountScreen());
                }),
                _buildOption(
                    context,
                    title: "View Account",
                    icon: Icons.account_circle, onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AccountView());
                }),
                _buildOption(
                  context,
                  title: "Deposit",
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => const DepositScreen());
                  },
                ),
                _buildOption(
                  context,
                  title: "Withdraw",
                  icon: Icons.attach_money,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => const WithdrawScreen());
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
