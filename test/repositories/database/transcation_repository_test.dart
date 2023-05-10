import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/repositories/database/transcation_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transcation_repository_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() async {
  group(
    'ContactRepository',
    () {
      final repository = MockTransactionRepository();
      test(
        'getContacts',
        () async {
          when(repository.getTransactions(1, '', '', 0)).thenAnswer(
            (_) async => <TransactionModel>[
              TransactionModel(
                id: 1,
                name: 'Transaction 1',
                category: 1,
                amount: 1000,
                date: DateTime.now(),
                description: 'Description 1',
              ),
              TransactionModel(
                id: 2,
                name: 'Transaction 2',
                category: 2,
                amount: 2000,
                date: DateTime.now(),
                description: 'Description 2',
              ),
            ],
          );

          List<TransactionModel> transaction =
              await repository.getTransactions(1, '', '', 0);

          expect(transaction.isNotEmpty, true);
          expect(transaction.length, 2);
          expect(transaction[0].id, 1);
          expect(transaction[1].id, 2);
        },
      );
    },
  );
}
