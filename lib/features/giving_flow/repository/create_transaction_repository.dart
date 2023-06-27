import 'package:givt_app_kids/features/giving_flow/models/transaction.dart';
import 'package:givt_app_kids/features/giving_flow/repository/data_providers/create_transaction_bff_backend_data_provider.dart';

class CreateTransactionRepository {
  Future<void> createTransaction({required Transaction transaction}) async {
    final legacyBackend = CreateTransactionBffBackendDataProvider();
    await legacyBackend.createTransaction(transaction: transaction);
  }
}
