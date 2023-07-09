import 'dart:ui';

// color name can be generated from :
// - https://www.color-name.com/
// - https://hexcolor.co/hex/828A94

class ColorHex {
  static Color blue = HexColor('#80A7FF');
  static Color green = HexColor('#A2FA92');
  static Color lime = HexColor('#9EBC00');
}

class HexColor extends Color {
  HexColor(String hex) : super(_getColorFromHex(hex));
  static int _getColorFromHex(String hexColor) =>
      int.parse('FF$hexColor'.replaceAll('#', ''), radix: 16);
}
