import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/product_remote_datasource.dart';
import '../../../../data/model/response/product_response_model.dart';



part 'get_products_event.dart';
part 'get_products_state.dart';
part 'get_products_bloc.freezed.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  final ProductRemoteDatasource datasource;
  GetProductsBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.getProducts();
      response.fold(
        (l) => emit(_Error(l)),
        (r) {
          emit(_Success(r.data!));
        },
      );
    });
  }
}
