import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());
  void changePage(int index) {
    switch (index) {
      case 0:
        emit(state.copyWith(
            activeDestination: NavigationDestinationData.values[0]));
        break;
      case 1:
        emit(state.copyWith(
            activeDestination: NavigationDestinationData.values[1]));
        break;
      case 2:
        emit(state.copyWith(
            activeDestination: NavigationDestinationData.values[2]));
        break;
      default:
        emit(state.copyWith(activeDestination: NavigationDestinationData.home));
    }
  }
}
