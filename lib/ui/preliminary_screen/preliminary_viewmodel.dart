import 'package:stacked/stacked.dart';

import 'package:mycreditloans/main.dart';
import 'package:mycreditloans/models/product.dart';
import 'package:mycreditloans/services/data_service.dart';

class PreliminaryViewModel extends BaseViewModel {
  final _dataService = getIt<DataService>();
  late Loan loan;

  void selectLoan() {
    _dataService.selectedLoan = loan;
  }

  void initModel() {
    loan = _dataService.loans[0];
    _periodGroup = loan.selectedPeriodMonths;
  }

  bool _isTcChecked = false;
  bool get isTcChecked => _isTcChecked;
  set isTcChecked(bool b) {
    _isTcChecked = b;
    notifyListeners();
  }

  late int _periodGroup;
  int get periodGroup => _periodGroup;
  set periodGroup(int b) {
    _periodGroup = b;
    notifyListeners();
  }
}
