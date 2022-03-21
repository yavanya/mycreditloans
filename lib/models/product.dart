class Loan {
  Loan({
    required this.minLoanAmount,
    required this.maxLoanAmount,
    required this.loanStep,
    required this.periodList,
    required this.interest,
    required this.currency,
  }) {
    selectedLoanAmount = minLoanAmount + loanStep;
    selectedPeriodMonths = periodList[2];
  }

  int minLoanAmount;
  int maxLoanAmount;
  int loanStep;
  List<int> periodList;
  int interest;
  String currency;

  late int selectedLoanAmount;
  late int selectedPeriodMonths;

  double get monthlyPayment => (selectedLoanAmount / selectedPeriodMonths +
      (selectedLoanAmount * interest / 100));

  double get totalPayment => monthlyPayment * selectedPeriodMonths;

  int get divisions => (maxLoanAmount - minLoanAmount) ~/ loanStep;

  String getPeriodString(int months) {
    if (months < 12) {
      return _getMonthsString(months);
    } else if (months % 12 == 0) {
      return _getYearsString(months);
    } else {
      return '${_getYearsString(months)}${_getMonthsString(months)}';
    }
  }

  String _getYearsString(int months) {
    final yrs = months ~/ 12;
    if (months == 0) {
      return '';
    } else if (yrs == 1) {
      return '$yrs year ';
    } else {
      return '$yrs years ';
    }
  }

  String _getMonthsString(int months) {
    if (months > 12) {
      months %= 12;
    }
    if (months == 1) {
      return '1 month';
    } else {
      return '$months months';
    }
  }
}
