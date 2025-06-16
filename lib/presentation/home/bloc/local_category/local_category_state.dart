part of 'local_category_bloc.dart';

@freezed
class LocalCategoryState with _$LocalCategoryState {
  const factory LocalCategoryState.initial() = _Initial;
  const factory LocalCategoryState.loading() = _Loading;
  const factory LocalCategoryState.loaded(List<CategoryModel> category) = _Loaded;
  const factory LocalCategoryState.error(String message) = _Error;
}
