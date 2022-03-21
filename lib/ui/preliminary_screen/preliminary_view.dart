import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

import 'package:mycreditloans/ui/common_widgets/dumb_slivers.dart';
import 'package:mycreditloans/ui/preliminary_screen/preliminary_viewmodel.dart';
import 'package:mycreditloans/ui/process_screen/process_view.dart';

class PreliminaryView extends StatelessWidget {
  const PreliminaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PreliminaryViewModel>.reactive(
        viewModelBuilder: () => PreliminaryViewModel(),
        onModelReady: (m) => m.initModel(),
        builder: (context, model, child) {
          return const SafeArea(
            child: Scaffold(
              body: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverGap(height: 24),
                  _LoanAmountSlider(),
                  SliverHorizontalDivider(height: 24),
                  _PeriodSelector(),
                  SliverHorizontalDivider(height: 24),
                  _PaymentInfo(),
                  SliverHorizontalDivider(height: 24),
                  _AcceptBlock(),
                ],
              ),
            ),
          );
        });
  }
}

class _LoanAmountSlider extends ViewModelWidget<PreliminaryViewModel> {
  const _LoanAmountSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, PreliminaryViewModel viewModel) {
    final loan = viewModel.loan;
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Loan Amount:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '${loan.selectedLoanAmount} ${loan.currency}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Slider.adaptive(
          value: loan.selectedLoanAmount.toDouble(),
          min: loan.minLoanAmount.toDouble(),
          max: loan.maxLoanAmount.toDouble(),
          divisions: loan.divisions,
          onChanged: (i) {
            loan.selectedLoanAmount = i.toInt();
            viewModel.notifyListeners();
          },
          label: '${loan.selectedLoanAmount} ${loan.currency}',
        ),
      ]),
    );
  }
}

class _PeriodSelector extends ViewModelWidget<PreliminaryViewModel> {
  const _PeriodSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, PreliminaryViewModel viewModel) {
    final loan = viewModel.loan;
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Period:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(loan.periodList.length, (i) {
          final isSelected = loan.periodList[i] == viewModel.periodGroup;
          return RadioListTile(
            value: loan.periodList[i],
            groupValue: viewModel.periodGroup,
            onChanged: (int? v) {
              loan.selectedPeriodMonths = v!;
              viewModel.periodGroup = v;
            },
            title: Text(
              loan.getPeriodString(
                loan.periodList[i],
              ),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                fontSize: isSelected ? 20 : 16,
              ),
            ),
          );
        })
      ]),
    );
  }
}

class _PaymentInfo extends ViewModelWidget<PreliminaryViewModel> {
  const _PaymentInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, PreliminaryViewModel viewModel) {
    final loan = viewModel.loan;
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              children: [
                const Text(
                  'Monthly Payment:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${loan.monthlyPayment.toStringAsFixed(2)} ${loan.currency}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              children: [
                const Text(
                  'Total Payment:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${loan.totalPayment.toStringAsFixed(2)} ${loan.currency}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptBlock extends ViewModelWidget<PreliminaryViewModel> {
  const _AcceptBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, PreliminaryViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: viewModel.isTcChecked
                ? () {
                    viewModel.selectLoan();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProcessView(),
                      ),
                    );
                  }
                : null,
            child: const Text(
              'Accept',
            ),
          ),
        ),
        CheckboxListTile(
          value: viewModel.isTcChecked,
          onChanged: (b) => viewModel.isTcChecked = b!,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              const TextSpan(
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                ),
                text: 'By checking the box, you confirm that you accept\n',
              ),
              TextSpan(
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 10,
                ),
                text: 'Terms of Service and Privacy Statement',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ChromeSafariBrowser().open(
                      url: Uri.parse(
                        'https://www.evonomix.com/contact/',
                      ),
                    );
                  },
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
