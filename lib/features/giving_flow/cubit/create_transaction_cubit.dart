import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/giving_flow/models/transaction.dart';
import 'package:givt_app_kids/features/giving_flow/repository/create_transaction_repository.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';

part 'create_transaction_state.dart';

class CreateTransactionCubit extends Cubit<CreateTransactionState> {
  CreateTransactionCubit({required this.profilesCubit})
      : super(CreateTransactionChooseAmountState(
            amount: 0, maxAmount: profilesCubit.state.activeProfile.balance));

  final ProfilesCubit profilesCubit;

  void changeAmount(double amount) {
    emit(CreateTransactionChooseAmountState(
        amount: amount.roundToDouble(),
        maxAmount: profilesCubit.state.activeProfile.balance.roundToDouble()));
  }

  Future<void> createTransaction({required Transaction transaction}) async {
    emit(CreateTransactionUploadingState(
        amount: state.amount, maxAmount: state.maxAmount));

    final createTransactionRepository = CreateTransactionRepository();
    try {
      await createTransactionRepository.createTransaction(
          transaction: transaction);
      emit(CreateTransactionSuccessState(
          amount: state.amount, maxAmount: state.maxAmount));
    } catch (error) {
      emit(CreateTransactionErrorState(
          amount: state.amount,
          maxAmount: state.maxAmount,
          errorMessage: error.toString()));
    }
  }
}
