import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/build_context_ext.dart';

class ServiceDialog extends StatelessWidget {
  const ServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'LAYANAN',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.cancel,
                color: AppColors.green,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Presentase (5%)'),
            subtitle: const Text('Biaya layanan'),
            contentPadding: EdgeInsets.zero,
            textColor: AppColors.green,
            trailing: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  loading: () => const CircularProgressIndicator(),
                  loaded: (data, a, b, c, d, service, e, f, g) => Checkbox(
                    value: service > 0,
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            CheckoutEvent.addServiceCharge(service > 0 ? 0 : 5),
                          );
                    },
                  ),
                );
              },
            ),
            onTap: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
