
class OptionModel<T> {
  T value;
  String label;
  bool? check;
  OptionModel({required this.value, required this.label, this.check});
}