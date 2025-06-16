part of 'local_category_bloc.dart';

@freezed
class LocalCategoryEvent with _$LocalCategoryEvent {
  const factory LocalCategoryEvent.started() = _Started;
  const factory LocalCategoryEvent.getLocalCategory() = _GetLocalCategory;
}