import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class TransactionMapper {
  static TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      title: model.title,
      amount: model.amount,
      type: model.type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: model.date,
      categoryId: model.categoryId,
      note: model.note,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static TransactionModel toModel(TransactionEntity entity) {
    final model = TransactionModel()
      ..id = entity.id
      ..title = entity.title
      ..amount = entity.amount
      ..type = entity.type.name
      ..date = entity.date
      ..categoryId = entity.categoryId
      ..note = entity.note
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
    return model;
  }
}
