import 'package:flutter/material.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({
    super.key,
    this.textAlign,
    this.width,
    this.height,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.fontWeight,
    this.font,
    this.fontSize,
    this.borderRadius,
    this.isBottomButton,
    this.paddingBottom,
    this.margin,
    this.borderColor,
  });

  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final double? paddingBottom;
  final String? title;
  final String? font;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final void Function()? onPressed;
  final TextAlign? textAlign;
  final bool? isBottomButton;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200,
      height: height ?? 45,
      child: SafeArea(
        top: false,
        bottom: isBottomButton == false,
        child: Padding(
          padding: margin ?? EdgeInsets.zero,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.grey.withOpacity(0.5),
              splashFactory: NoSplash.splashFactory,
              backgroundColor: backgroundColor ?? Colors.black,
              shadowColor: Colors.transparent,
              minimumSize: Size(width ?? double.infinity, height ?? 40),
              shape: RoundedRectangleBorder(
                side: borderColor == null
                    ? BorderSide.none
                    : BorderSide(color: borderColor!, width: 1.5),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
            ),
            child: Center(
              child: Text(
                title ?? '',
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  color: textColor ?? Colors.black,
                  fontWeight: fontWeight ?? FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
