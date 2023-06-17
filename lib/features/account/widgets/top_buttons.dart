import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/services/account_service.dart';
import 'package:kmutnb_project/features/account/widgets/account_button.dart';
import 'package:kmutnb_project/features/account/widgets/order_return.dart';
import 'package:kmutnb_project/features/account/widgets/order_sucees.dart';

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
              text: 'ได้รับแล้ว',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersSucees(),
                  ),
                );
              },
            ),
            AccountButtons(
              text: 'คืนสินค้า',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersReturn(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
