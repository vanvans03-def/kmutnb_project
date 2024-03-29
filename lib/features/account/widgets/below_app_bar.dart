import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: 'ยินดีต้อนรับ, ',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: user.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
