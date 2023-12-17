part of 'flows_cubit.dart';

class FlowsState extends Equatable {
  const FlowsState({
    required this.flowType,
  });

  final FlowType flowType;

  bool get isCoin {
    return flowType == FlowType.inAppCoin || flowType == FlowType.deepLinkCoin;
  }

  bool get isQRCode {
    return flowType == FlowType.inAppQRCode;
  }

  bool get isRecommendation {
    return flowType == FlowType.recommendation;
  }

  bool get isExhibition {
    return flowType == FlowType.exhibition;
  }

  @override
  List<Object> get props => [flowType];
}
