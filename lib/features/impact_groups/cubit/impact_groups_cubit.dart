import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/logging/logging_service.dart';
import 'package:givt_app_kids/features/impact_groups/model/goal.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';
import 'package:givt_app_kids/features/impact_groups/repository/impact_groups_repository.dart';

part 'impact_groups_state.dart';

class ImpactGroupsCubit extends Cubit<ImpactGroupsState> {
  ImpactGroupsCubit(
    this._impactGroupInviteRepository,
  ) : super(const ImpactGroupsState());

  final ImpactGroupsRepository _impactGroupInviteRepository;

  String dissmissedGoalKey(String childId) {
    return '$childId-dissmissedGoalKey';
  }

  Future<void> fetchImpactGroups() async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));

    try {
      final impactGroups =
          await _impactGroupInviteRepository.fetchImpactGroups();

      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.fetched,
          groups: impactGroups,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error('Error while fetching impact groups: $error',
          methodName: stackTrace.toString());
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: error.toString(),
        ),
      );
    }
  }
}
