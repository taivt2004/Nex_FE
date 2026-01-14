import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/feature/login.register/bloc/login_bloc.dart';
import 'package:nexpaylab/feature/login.register/bloc/login_event.dart';
import 'package:nexpaylab/feature/login.register/bloc/login_state.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/extensions/widget.dart';
import 'package:nexpaylab/share/ui/widget/custom.textfield.dart';
import 'package:nexpaylab/share/ui/widget/nice_buttons.dart';
import 'package:nexpaylab/share/ui/widget/toast/info_toast.dart';
import 'package:nexpaylab/share/utils/dimensions.dart';

@injectable
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = true;
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
        final emailOrPhone = _usernameController.text;
        final password = _passwordController.text;

        context.read<LoginBloc>().add(
              LoginButtonPressed(
                username: emailOrPhone,
                password: password,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          inProgress = true;
        } else if (state is LoginFailure) {
          onFinishLoading?.call();
          InfoToast.error(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor,
            title: Text(state.error),
            displayTitle: false,
            description: Text(state.error),
            animationDuration: const Duration(
              milliseconds: 1000,
            ),
            autoDismiss: false,
          ).show(context);
        } else if (state is LoginSuccess) {
          onFinishLoading?.call();
          context.pop();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  'Hãy đăng nhập để tiếp tục nhé',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          semanticLabel: 'Nhớ mật khẩu',
                          side: const BorderSide(
                            color: OlaColors.gray300,
                          ),
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Nhớ mật khẩu',
                          style: OlaTextStyles.primarytext14regular,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Quên mật khẩu?',
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
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: NiceButtons(
                  height: Dimension.buttonHeight,
                  progress: inProgress,
                  onTap: (VoidCallback finish) {
                    if (mounted) {
                      onFinishLoading = finish;
                      _onLoginPressed(context);
                    }
                  },
                  child: Text(
                    'ĐĂNG NHẬP',
                    style: OlaTextStyles.primarytext14medium,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.end,
                    'Bạn chưa có tài khoản?',
                    style: OlaTextStyles.subtext12regular,
                  ),
                  TextButton(
                    onPressed: () async {
                      final success = await context.push<bool>(
                        AppRouter.register,
                      );
                      if (context.mounted && success != null && success) {
                        context.pop();
                      }
                    },
                    child: Text(
                      'Đăng kí',
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
    ).toContainerWidget(
      context: context,
      safeArea: true,
      showAppBar: true,
      appBoarTitle: Text(
        'ĐĂNG NHẬP',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      leading: const BackButton(),
    );
  }
}
