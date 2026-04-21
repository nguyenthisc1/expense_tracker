import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository _categoryRepository;

  const DeleteCategoryUsecase(this._categoryRepository);

  Future<void> call(String id) async {
    final category = await _categoryRepository.getCategoryById(id);

    if (category == null) {
      throw const NotFoundException('Category was not found.');
    }

    final isInUse = await _categoryRepository.isCategoryInUse(id);

    if (isInUse) {
      throw const BusinessRuleException(
        'Cannot delete category because it is being used by transactions.',
      );
    }

    await _categoryRepository.deleteCategory(id);
  }
}
