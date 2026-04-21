import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class GetCategoryByIdUsecase {
  final CategoryRepository _categoryRepository;

  const GetCategoryByIdUsecase(this._categoryRepository);

  Future<CategoryEntity> call(String id) async {
    final category = await _categoryRepository.getCategoryById(id);

    if (category == null) {
      throw const NotFoundException('Category was not found.');
    }

    return category;
  }
}
