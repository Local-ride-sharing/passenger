import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tmoto_passenger/src/utils/constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with HydratedMixin {
  ThemeCubit() : super(ThemeState(value: ThemeValue.systemPreferred));

  void changeTheme(int value) {
    emit(ThemeState(value: value));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toMap();
  }
}
