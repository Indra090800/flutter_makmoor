part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;
  //addproduct
  const factory CheckoutEvent.addProduct(Product product) = _AddProduct;
  //removeproduct
  const factory CheckoutEvent.removeProduct(Product product) = _RemoveProduct;

  //add discount
  const factory CheckoutEvent.addDiscount(Discount discount) = _AddDiscount;
  //remove discount
  const factory CheckoutEvent.removeDiscount() = _RemoveDiscount;
  //add tax
  const factory CheckoutEvent.addTax(int tax) = _AddTax;
  //add service charge
  const factory CheckoutEvent.addServiceCharge(int serviceCharge) = _AddServiceCharge;
}