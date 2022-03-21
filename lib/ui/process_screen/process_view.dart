import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycreditloans/ui/result_screen/result_view.dart';
import 'package:stacked/stacked.dart';

import 'package:mycreditloans/helpers/string_helpers.dart';
import 'package:mycreditloans/models/enums.dart';
import 'package:mycreditloans/ui/process_screen/process_viewmodel.dart';

class ProcessView extends StatelessWidget {
  const ProcessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProcessViewModel>.reactive(
        viewModelBuilder: () => ProcessViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const _AppBar(),
                  const _NameBlock(),
                  const _OccupationBlock(),
                  if (model.occupation == Occupation.employed) ...[
                    const _JobBlock(),
                  ],
                  const _InvoiceBlock(),
                  const _ValidateApplyBlock(),
                ],
              ),
            ),
          );
        });
  }
}

class _AppBar extends ViewModelWidget<ProcessViewModel> {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return const SliverAppBar(
      title: Text('Form'),
    );
  }
}

class _NameBlock extends ViewModelWidget<ProcessViewModel> {
  const _NameBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Form(
        key: viewModel.nameKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 16,
                bottom: 4,
              ),
              child: Text(
                'First Name:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: viewModel.firstNameController,
                validator: (v) => viewModel.validator(v),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 16,
                bottom: 4,
              ),
              child: Text(
                'Last Name:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: viewModel.lastNameController,
                validator: (v) => viewModel.validator(v),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccupationBlock extends ViewModelWidget<ProcessViewModel> {
  const _OccupationBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return SliverList(
        delegate: SliverChildListDelegate([
      const Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 4,
        ),
        child: Text(
          'Occupation:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      RadioListTile(
          value: Occupation.employed,
          groupValue: viewModel.occupation,
          title: Text(capitalize(Occupation.employed.name)),
          onChanged: (Occupation? o) => viewModel.occupation = o!),
      RadioListTile(
          value: Occupation.unemployed,
          groupValue: viewModel.occupation,
          title: Text(capitalize(Occupation.unemployed.name)),
          onChanged: (Occupation? o) {
            viewModel.occupation = o!;
          }),
    ]));
  }
}

class _JobBlock extends ViewModelWidget<ProcessViewModel> {
  const _JobBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Form(
          key: viewModel.jobKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 4,
                ),
                child: Text(
                  'Job Title:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: viewModel.jobController,
                  validator: (v) => viewModel.validator(v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 4,
                ),
                child: Text(
                  'Monthly Income:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: viewModel.incomeController,
                  validator: (v) => viewModel.validator(v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class _InvoiceBlock extends ViewModelWidget<ProcessViewModel> {
  const _InvoiceBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Padding(
            padding: EdgeInsets.only(
              top: 16,
              bottom: 4,
            ),
            child: Text(
              'Invoice Picture:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          viewModel.image == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.blueAccent,
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            final res = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (ctx) => const _PickerSourceSelector(),
                            );

                            if (res != null) {
                              viewModel.image = res;
                              viewModel.notifyListeners();
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.file(
                    File(
                      viewModel.image!.path,
                    ),
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (frame != null) {
                        return child;
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Processing Image...'),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: LinearProgressIndicator(),
                            ),
                          ],
                        );
                      }
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
        ],
      ),
    );
  }
}

class _ValidateApplyBlock extends ViewModelWidget<ProcessViewModel> {
  const _ValidateApplyBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProcessViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            viewModel.validateClient();
            if (viewModel.isValid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ResultView(),
                ),
              );
            }
          },
          child: const Text(
            'Apply for a Loan',
          ),
        ),
      ),
    );
  }
}

class _PickerSourceSelector extends StatelessWidget {
  const _PickerSourceSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              IconButton(
                onPressed: () async {
                  final image =
                      await ImagePicker().pickImage(source: ImageSource.camera);

                  Navigator.pop(context, image);
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.blueAccent,
                  size: 36,
                ),
              ),
              const Text('Camera'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              IconButton(
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  Navigator.pop(context, image);
                },
                icon: const Icon(
                  Icons.folder,
                  color: Colors.blueAccent,
                  size: 36,
                ),
              ),
              const Text('Gallery'),
            ],
          ),
        ),
      ]),
    );
  }
}
