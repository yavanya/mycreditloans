import 'package:mycreditloans/models/enums.dart';

class Client {
  Client({
    required this.firstName,
    required this.lastName,
    required this.occupation,
    required this.monthlyIncome,
    required this.invoicePath,
  });
  final String firstName;
  final String lastName;
  final Occupation occupation;
  int monthlyIncome;
  String invoicePath;
}
