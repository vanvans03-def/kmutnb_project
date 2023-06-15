import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/services/account_service.dart';
import 'package:kmutnb_project/features/account/widgets/account_button.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButtons(
              text: 'ออเดอร์ของคุณ',
              onTap: () {},
            ),
            AccountButtons(
              text: 'คืนสินค้า',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
