import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/model/request/product_request_model.dart';
import '../../../../data/datasource/product_remote_datasource.dart';
import '../../../../data/model/response/product_response_model.dart';



part 'add_product_event.dart';
part 'add_product_state.dart';
part 'add_product_bloc.freezed.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRemoteDatasource datasource;
  AddProductBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_AddProduct>((event, emit) async {
      emit(const _Loading());
      final requestData = ProductRequestModel(
        name: event.product.name!,
        price: int.parse(event.product.price!),
        stock: event.product.stock!,
        categoryId: event.product.categoryId!,
        isBestSeller: event.product.isFavorite!,
        image: event.image,
      );
      log("requestData: ${requestData.toString()}");
      final response = await datasource.addProduct(requestData);
      // products.add(newProduct);
      response.fold(
        (l) => emit(_Error(l)),
        (r) {
          emit(_Success('Add Product Success'));
        },
      );
    });
  }
}
