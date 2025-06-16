import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/category_remote_datasource.dart';
import '../../../../data/model/response/category_response_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first


part 'sync_category_bloc.freezed.dart';
part 'sync_category_event.dart';
part 'sync_category_state.dart';

class SyncCategoryBloc extends Bloc<SyncCategoryEvent, SyncCategoryState> {
  final CategoryRemoteDatasource categoryRemoteDatasource;
  SyncCategoryBloc(
    this.categoryRemoteDatasource,
  ) : super(const _Initial()) {
    on<SyncCategoryEvent>((event, emit)async {
      emit(const _Loading());
      final result = await categoryRemoteDatasource.getCategories();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
