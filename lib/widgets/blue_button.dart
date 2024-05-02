import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import '../utils/hex_color.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    super.key,
    this.size = -1,
    required this.title,
    required this.onTap,
    this.isDisabled = false,
  });

  final double size;
  final String title;
  final void Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    double buttonSize =
        size >= 0 ? size : MediaQuery.of(context).size.width * 0.9;

    return GestureDetector(
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: HexColor(isDisabled ? neutral10 : mariner700),
          borderRadius: BorderRadius.circular(15),
        ),
        width: buttonSize,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: CustomTextStyle.bold16.copyWith(
                  color: isDisabled ? HexColor(secondaryGrey) : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
