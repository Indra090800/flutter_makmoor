import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/response/table_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/product_local_datasource.dart';


part 'get_table_event.dart';
part 'get_table_state.dart';
part 'get_table_bloc.freezed.dart';

class GetTableBloc extends Bloc<GetTableEvent, GetTableState> {
  GetTableBloc() : super(_Initial()) {
    on<_GetTables>((event, emit) async {
      emit(_Loading());
      final tables = await ProductLocalDatasource.instance.getAllTable();
      emit(_Success(tables));
    });
  }
}
