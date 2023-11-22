import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  FlowsCubit() : super(const FlowsState(flowType: FlowType.none));

  void startDeepLinkCoinFlow() {
    emit(const FlowsState(flowType: FlowType.deepLinkCoin));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', false);
  }

  void startInAppCoinFlow() {
    emit(const FlowsState(flowType: FlowType.inAppCoin));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', true);
  }

  void startInAppQRCodeFlow() {
    emit(const FlowsState(flowType: FlowType.inAppQRCode));
  }

  void startRecommendationFlow() {
    emit(const FlowsState(flowType: FlowType.recommendation));
  }

  void resetFlow() {
    emit(const FlowsState(flowType: FlowType.none));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', false);
  }
}
