import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  FlowsCubit() : super(const FlowsState(flowType: FlowType.none));

  void startDeepLinkCoinFlow() {
    emit(const FlowsState(flowType: FlowType.deepLinkCoin));
  }

  void startInAppCoinFlow() {
    emit(const FlowsState(flowType: FlowType.inAppCoin));
  }

  void startInAppQRCodeFlow() {
    emit(const FlowsState(flowType: FlowType.inAppQRCode));
  }

  void resetFlow() {
    emit(const FlowsState(flowType: FlowType.none));
  }
}
