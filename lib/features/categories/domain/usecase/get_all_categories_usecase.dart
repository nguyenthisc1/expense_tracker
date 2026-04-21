import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository _categoryRepository;

  const GetAllCategoriesUsecase(this._categoryRepository);

  Future<List<CategoryEntity>> call() {
    return _categoryRepository.getAllCategories();
  }
}
