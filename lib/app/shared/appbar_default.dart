import 'package:flutter/material.dart';
import 'package:uuite/app/constant/assets.dart';
import 'package:uuite/app/shared/text_default.dart';

class AppBarDefault extends StatelessWidget {
  const AppBarDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Center(
        child: Column(
          children: [
            Image.asset(Assets.logo, width: 120),
            const SizedBox(height: 10),
            const TextDefault(
              'INFORMASI DAN TRANSAKSI ELEKTRONIK\nUU NO.11 2008 - UU NO.19 2016',
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            const Divider(height: 30, thickness: 1, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
