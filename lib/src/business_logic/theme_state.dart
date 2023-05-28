part of 'theme_cubit.dart';

class ThemeState {
  int value;

  ThemeState({required this.value});

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(value: map['value']);
  }
}