import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class UpdateCategoryUsecase {
  final CategoryRepository _categoryRepository;

  const UpdateCategoryUsecase(this._categoryRepository);

  Future<CategoryEntity> call(CategoryEntity category) async {
    if (category.name.trim().isEmpty) {
      throw const ValidationException('Category name cannot be empty.');
    }

    final existingCategory = await _categoryRepository.getCategoryById(
      category.id,
    );

    if (existingCategory == null) {
      throw const NotFoundException('Category was not found.');
    }

    final exists = await _categoryRepository.existsCategoryName(
      name: category.name.trim(),
      type: category.type,
      excludeId: category.id,
    );

    if (exists) {
      throw const BusinessRuleException(
        'A category with the same name already exists for this type.',
      );
    }

    return _categoryRepository.updateCategory(category);
  }
}
