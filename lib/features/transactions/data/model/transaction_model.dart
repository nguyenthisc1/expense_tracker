import 'package:isar/isar.dart';

class TransactionModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  late double amount;
  late String type;
  late DateTime date;
  late String categoryId;
  String? note;
  late DateTime createdAt;
  late DateTime updatedAt;
}
