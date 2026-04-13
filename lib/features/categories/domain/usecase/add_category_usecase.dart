import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class AddCategoryUsecase {
  final CategoryRepository _categoryRepository;

  const AddCategoryUsecase(this._categoryRepository);

  Future<CategoryEntity> call(CategoryEntity category) async {
    if (category.name.trim().isEmpty) {
      throw const ValidationException('Category name cannot be empty.');
    }

    final exists = await _categoryRepository.existsCategoryName(
      name: category.name.trim(),
      type: category.type,
    );

    if (exists) {
      throw const BusinessRuleException(
        'A category with the same name already exists for this type.',
      );
    }

    return _categoryRepository.addCategory(category);
  }
}
