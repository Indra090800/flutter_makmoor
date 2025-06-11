import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/category_remote_datasource.dart';
import '../../../../data/model/response/category_response_model.dart';



part 'get_categories_event.dart';
part 'get_categories_state.dart';
part 'get_categories_bloc.freezed.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final CategoryRemoteDatasource datasource;
  GetCategoriesBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.getCategories();
      result.fold(
        (l) => emit(_Error(l)),
        (r) async {
          emit(_Success(r.data));
        },
      );
    });
  }
}
