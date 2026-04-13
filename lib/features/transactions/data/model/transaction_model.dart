import 'package:isar/isar.dart';

class TransactionModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late DateTime date;

  @Index()
  late String categoryId;

  @Index()
  late String type;

  late String title;
  late double amount;
  String? note;
  late DateTime createdAt;
  late DateTime updatedAt;
}
