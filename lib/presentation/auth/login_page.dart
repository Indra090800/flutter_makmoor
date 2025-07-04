import 'bloc/login/login_bloc.dart';
import '../../components/spaces.dart';
import '../../components/buttons.dart';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/assets/assets.gen.dart';
import '../home/pages/dashboard_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/custom_text_field.dart';
import '../../data/datasource/auth_local_datasource.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 260.0, vertical: 20.0),
        children: [
          const SpaceHeight(80.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: Image.asset(
                'assets/images/makmoor.png',
                width: 100,
                height: 100,
              )),
          const SpaceHeight(24.0),
          // const Center(
          //   child: Text(
          //     'MAKMOOR APPS',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w700,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              'Akses Login Kasir ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SpaceHeight(40.0),
          CustomTextField(
            controller: emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: () => setState(() {
                isPasswordVisible = !isPasswordVisible;
              }),
              child: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
          const SpaceHeight(24.0),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (authResponseModel) {
                  AuthLocalDataSource().saveAuthData(authResponseModel);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
              );
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return Button.filled(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              LoginEvent.login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                      label: 'Masuk',
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
