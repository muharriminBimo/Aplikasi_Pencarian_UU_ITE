import 'package:flutter/material.dart';

class TextDefault extends StatelessWidget {
  const TextDefault(
    this.text, {
    super.key,
    this.fontFamily,
    this.fontSize = 14,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.letterSpacing,
    this.height,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.fontStyle,
  });

  final String text;
  final String? fontFamily;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      style: TextStyle(
        fontFamily: fontFamily,
        height: height,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      ),
    );
  }
}
