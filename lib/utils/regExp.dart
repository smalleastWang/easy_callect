
class RegExpValidator {
  static numberAndLetter(String? v, [String? fieldName]) {
    if (v == null || v.trim().isEmpty) {
      return '$fieldName不能为空';
    }
    // 匹配仅包含数字和英文字母的正则表达式
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regExp.hasMatch(v)) {
      return '$fieldName只能包含数字和英文字母';
    }
    return null;
  }
}