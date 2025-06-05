import 'package:bloc/bloc.dart';
import '../../models/order_item.dart';
import '../../models/product_model.dart';
import '../../models/product_quantity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/model/response/product_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const _Loaded([])) {
    on<_AddProduct>((event, emit) {
      var currentStates = state as _Loaded;
      List<ProductQuantity> items = [...currentStates.items];
      var index =
          items.indexWhere((element) => element.product.id == event.product.id);
      if (index != -1) {
        items[index] = ProductQuantity(
            product: event.product, quantity: items[index].quantity + 1);
      } else {
        items.add(ProductQuantity(product: event.product, quantity: 1));
      }
      emit(_Loaded(items));
    });

    on<_RemoveProduct>((event, emit) {
      var currentStates = state as _Loaded;
      List<ProductQuantity> items = [...currentStates.items];
      var index =
          items.indexWhere((element) => element.product.id == event.product.id);
      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index] = ProductQuantity(
              product: event.product, quantity: items[index].quantity - 1);
        } else {
          items.removeAt(index);
        }
      }
      emit(_Loaded(items));
    });

    on<_Started>((event, emit) {
      emit(const _Loaded([]));
    });
  }
}
