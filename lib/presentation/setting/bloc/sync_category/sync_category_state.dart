part of 'sync_category_bloc.dart';

@freezed
class SyncCategoryState with _$SyncCategoryState {
  const factory SyncCategoryState.initial() = _Initial;
  const factory SyncCategoryState.loading() = _Loading;
  const factory SyncCategoryState.loaded(CategroyResponseModel categoryResponseModel) = _Loaded;
  const factory SyncCategoryState.error(String message) = _Error;
}
