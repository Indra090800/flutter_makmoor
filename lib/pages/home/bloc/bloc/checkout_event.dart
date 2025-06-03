part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;
  //addproduct
  const factory CheckoutEvent.addProduct(Product product) = _AddProduct;
  //removeproduct
  const factory CheckoutEvent.removeProduct(Product product) = _RemoveProduct;
}