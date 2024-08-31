
class RegExpValidator {
  static numner(String? v, [String? fieldName]) {
    if (v == null || v.trim().isNotEmpty) {
      return '$fieldName不能为空';
    }
    RegExp numer = RegExp(r'[0-9]');
    if (numer.hasMatch(v)) {
      return '$fieldName只能是数字';
    }
    return null;
  }
}