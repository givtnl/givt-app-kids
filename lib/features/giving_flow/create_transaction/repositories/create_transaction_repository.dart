import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';

mixin CreateTransactionRepository {
  Future<void> createTransaction({required Transaction transaction});
}

class CreateTransactionRepositoryImpl with CreateTransactionRepository {
  CreateTransactionRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> createTransaction({required Transaction transaction}) async {
    await _apiService.createTransaction(transaction: transaction);
  }
}
