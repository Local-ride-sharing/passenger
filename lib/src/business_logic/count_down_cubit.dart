import 'package:bloc/bloc.dart';

class CountDownCubit extends Cubit<int> {
  CountDownCubit() : super(0);

  void initiate(int value) {
    emit(value);
  }

  startCountDown() async {
    while (!state.isNegative) {
      await Future.delayed(Duration(seconds: 1));
      emit(state - 1);
    }
  }
}
