import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/feature/login.register/bloc/register_bloc.dart';
import 'package:nexpaylab/feature/login.register/bloc/register_event.dart';
import 'package:nexpaylab/feature/login.register/bloc/register_state.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/extensions/widget.dart';
import 'package:nexpaylab/share/ui/widget/custom.textfield.dart';
import 'package:nexpaylab/share/ui/widget/nice_buttons.dart';
import 'package:nexpaylab/share/ui/widget/toast/info_toast.dart';
import 'package:nexpaylab/share/utils/dimensions.dart';

@injectable
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _usernameError;
  String? _passwordError;
  bool inProgress = false;
  VoidCallback? onFinishLoading;

  void _onLoginPressed(BuildContext context) {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty ? 'Cần nhập tên đăng nhập' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Cần nhập mật khẩu' : null;

      if (_usernameError == null && _passwordError == null) {
        final username = _usernameController.text;
        final password = _passwordController.text;

        context.read<RegisterBloc>().add(
              RegisterButtonPressed(username: username, password: password),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          inProgress = true;
        }
        if (state is RegisterFailure) {
          onFinishLoading?.call();
          InfoToast.error(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shadowColor: Theme.of(context).shadowColor,
            title: Text(state.error),
            displayTitle: false,
            description: Text(state.error),
            animationDuration: const Duration(milliseconds: 1000),
            autoDismiss: false,
          ).show(context);
        }
        if (state is RegisterSuccess) {
          onFinishLoading?.call();
          context.pop(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  Text(
                    'Hãy tạo tài khoản để sử dụng đầy đủ tính năng',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    hintText: ' Tên đăng nhập',
                    labelText: 'Tên đăng nhập',
                    errorText: _usernameError,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: ' Mật khẩu ít nhất 6 kí tự',
                    labelText: 'Mật khẩu ít nhất 6 kí tự',
                    errorText: _passwordError,
                    textInputAction: TextInputAction.done,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NiceButtons(
                  height: Dimension.buttonHeight,
                  progress: inProgress,
                  onTap: (VoidCallback finish) {
                    onFinishLoading = finish;
                    _onLoginPressed(context);
                  },
                  child: Text(
                    'TẠO TÀI KHOẢN',
                    style: OlaTextStyles.primarytext14medium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Điều khoản sử dụng dịch vụ',
                      style: OlaTextStyles.subtext12regular,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Xem chi tiết',
                        style: OlaTextStyles.primarytext14bold.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).toContainerWidget(
      context: context,
      safeArea: true,
      showAppBar: true,
      appBoarTitle: Text(
        'ĐĂNG KÝ TÀI KHOẢN',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      leading: const BackButton(),
    );
  }
}
