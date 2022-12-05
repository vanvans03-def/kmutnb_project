import 'package:flutter/material.dart';
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
              text: 'Your Orders',
              onTap: () {},
            ),
            AccountButtons(
              text: 'Turn Seller',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButtons(
              text: 'Log Out',
              onTap: () {},
            ),
            AccountButtons(
              text: 'Your Wish List',
              onTap: () {},
            ),
          ],
        )
      ],
    );
  }
}
