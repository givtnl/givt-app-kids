part of 'recommendation_cubit.dart';

class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object> get props => [];
}

class RecommendationInitial extends RecommendationState {}

class RecommendationSent extends RecommendationState {}

class RecommendationSendFailed extends RecommendationState {}
