import 'package:isar/isar.dart';

@collection
class CategoryModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late String type;
  late int colorValue;
  late String iconName;
  late bool isDefault;
}
