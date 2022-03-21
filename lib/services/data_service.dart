import 'package:mycreditloans/main.dart';
import 'package:mycreditloans/api/json_api.dart';
import 'package:mycreditloans/models/product.dart';

class DataService {
  final jsonApi = getIt<JsonApi>();
  final loans = <Loan>[];
  Loan? selectedLoan;

  Future<void> init() async {
    final map = await jsonApi.getInitialData();
    final List loansList = map['loans'] ?? <dynamic>[];

    if (loansList.isNotEmpty) {
      for (var item in loansList) {
        final minLoanAmount = item['min'];
        final maxLoanAmount = item['max'];
        final loanStep = item['step'];
        final rawList = item['periods'].map((i) => i as int).toList();
        final interest = item['interest'];
        final currency = item['currency'];

        final periodList = <int>[];
        for (var item in rawList) {
          periodList.add(item);
        }

        loans.add(
          Loan(
            minLoanAmount: minLoanAmount,
            maxLoanAmount: maxLoanAmount,
            loanStep: loanStep,
            periodList: periodList,
            interest: interest,
            currency: currency,
          ),
        );
      }
    }
  }
}
