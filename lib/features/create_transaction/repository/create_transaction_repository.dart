import 'package:givt_app_kids/features/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/create_transaction/repository/data_providers/create_transaction_bff_backend_data_provider.dart';

class CreateTransactionRepository {
  Future<void> createTransaction({required Transaction transaction}) async {
    final legacyBackend = CreateTransactionBffBackendDataProvider();
    await legacyBackend.createTransaction(transaction: transaction);
  }
}
