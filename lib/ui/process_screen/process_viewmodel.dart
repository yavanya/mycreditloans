import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import 'package:mycreditloans/models/enums.dart';

class ProcessViewModel extends BaseViewModel {
  XFile? image;
  final nameKey = GlobalKey<FormState>();
  final jobKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final jobController = TextEditingController();
  final incomeController = TextEditingController();

  bool _isValid = false;
  bool get isValid => _isValid;
  set isValid(bool b) {
    _isValid = b;
    notifyListeners();
  }

  Occupation _occupation = Occupation.employed;
  Occupation get occupation => _occupation;
  set occupation(Occupation o) {
    _occupation = o;
    notifyListeners();
  }

  String? validator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Please fill the form';
    }
    return null;
  }

  void validateClient() {
    var jobValid = true;
    final nameValid = nameKey.currentState!.validate();

    if (occupation == Occupation.employed) {
      jobValid = jobKey.currentState!.validate();
    }

    final hasPic = image != null;
    isValid = nameValid && jobValid && hasPic;
  }
}
