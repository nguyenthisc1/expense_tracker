import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class IsCategoryInUseUsecase {
  final CategoryRepository _categoryRepository;

  const IsCategoryInUseUsecase(this._categoryRepository);

  Future<bool> call(String id) async {
    return await _categoryRepository.isCategoryInUse(id);
  }
}
