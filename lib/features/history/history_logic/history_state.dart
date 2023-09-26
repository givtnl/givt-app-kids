part of 'history_cubit.dart';

enum HistroryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  const HistoryState(
      {this.status = HistroryStatus.initial,
      this.history = const [],
      this.error = ''});

  final HistroryStatus status;
  final List<dynamic> history;
  final String error;

  @override
  List<Object> get props => [status, history, error];

  HistoryState copyWith({
    HistroryStatus? status,
    List<dynamic>? history,
    String? error,
  }) {
    return HistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      error: error ?? this.error,
    );
  }
}
