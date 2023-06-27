import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/giving_flow/models/transaction.dart';
import 'package:givt_app_kids/features/giving_flow/repository/create_transaction_repository.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';

part 'create_transaction_state.dart';

class CreateTransactionCubit extends Cubit<CreateTransactionState> {
  CreateTransactionCubit({required this.profilesCubit})
      : super(CreateTransactionChooseAmountState(
            amount: 0,
            maxAmaount: profilesCubit.state.activeProfile.wallet.balance));

  final ProfilesCubit profilesCubit;

  void changeAmount(double amount) {
    emit(CreateTransactionChooseAmountState(
        amount: amount.roundToDouble(),
        maxAmaount:
            profilesCubit.state.activeProfile.wallet.balance.roundToDouble()));
  }

  Future<void> createTransaction({required Transaction transaction}) async {
    emit(CreateTransactionUploadingState(
        amount: state.amount, maxAmaount: state.maxAmaount));

    final createTransactionRepository = CreateTransactionRepository();
    try {
      await createTransactionRepository.createTransaction(
          transaction: transaction);
      emit(CreateTransactionSuccessState(
          amount: state.amount, maxAmaount: state.maxAmaount));
    } catch (error) {
      emit(CreateTransactionErrorState(
          amount: state.amount,
          maxAmaount: state.maxAmaount,
          errorMessage: error.toString()));
    }
  }
}
