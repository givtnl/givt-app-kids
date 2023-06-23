part of 'create_transaction_cubit.dart';

abstract class CreateTransactionState extends Equatable {
  const CreateTransactionState(
      {required this.amount, required this.maxAmaount});

  final double amount;
  final double maxAmaount;

  @override
  List<Object> get props => [amount, maxAmaount];
}

class CreateTransactionChooseAmountState extends CreateTransactionState {
  const CreateTransactionChooseAmountState(
      {required super.amount, required super.maxAmaount});
}

class CreateTransactionUploadingState extends CreateTransactionState {
  const CreateTransactionUploadingState(
      {required super.amount, required super.maxAmaount});
}

class CreateTransactionSuccessState extends CreateTransactionState {
  const CreateTransactionSuccessState(
      {required super.amount, required super.maxAmaount});
}

class CreateTransactionErrorState extends CreateTransactionState {
  const CreateTransactionErrorState(
      {required super.amount,
      required super.maxAmaount,
      required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [amount, maxAmaount, errorMessage];
}
