import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/product_local_datasource.dart';
import '../../../../data/model/response/category_response_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first


part 'local_category_bloc.freezed.dart';
part 'local_category_event.dart';
part 'local_category_state.dart';

class LocalCategoryBloc extends Bloc<LocalCategoryEvent, LocalCategoryState> {
  final ProductLocalDatasource productLocalDatasource;
  LocalCategoryBloc(
    this.productLocalDatasource,
  ) : super(const _Initial()) {
    on<_GetLocalCategory>((event, emit)async {
       emit(const _Loading());
      final result = await productLocalDatasource.getCategories();

      emit(_Loaded(result));
    });
  }
}
