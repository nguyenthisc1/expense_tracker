import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository _categoryRepository;

  const GetCategoriesUsecase(this._categoryRepository);

  Future<List<CategoryEntity>> call({TransactionType? type}) {
    return _categoryRepository.getCategories(type: type);
  }
}
