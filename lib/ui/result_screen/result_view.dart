import 'package:flutter/material.dart';
import 'package:mycreditloans/ui/common_widgets/loading_widget.dart';
import 'package:mycreditloans/ui/result_screen/result_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResultViewModel>.reactive(
      viewModelBuilder: () => ResultViewModel(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const LoadingWidget();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Result'),
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your Score:',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    model.score!,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
