import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variable.dart';
import '../../pages/home/models/order_model.dart';

class OrderRemoteDatasource {
  Future<bool> saveOrder(OrderModel orderModel) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variable.baseUrl}/api/save-order');

    final response = await http.post(url, body: orderModel.toJson(), headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    print('order: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
