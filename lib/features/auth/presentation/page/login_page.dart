import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/login_bloc.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/login_event.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/login_state.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/extensions/widget.dart';
import 'package:nexpaylab/shared/ui/widget/custom_textfield.dart';
import 'package:nexpaylab/shared/ui/widget/nice_buttons.dart';
import 'package:nexpaylab/shared/ui/widget/password_text_field.dart';
import 'package:nexpaylab/shared/ui/widget/toast/info_toast.dart';
import 'package:nexpaylab/shared/utils/dimensions.dart';
import 'package:nexpaylab/shared/utils/error_translator.dart';
import 'package:nexpaylab/shared/utils/validator.dart';

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

  bool _rememberMe = true;
  String? _usernameError;
  String? _passwordError;
  bool inProgress = false;
  VoidCallback? onFinishLoading;

  void _onLoginPressed(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _usernameError = Validator.validateUsername(_usernameController.text, l10n);
      _passwordError = Validator.validatePassword(_passwordController.text, l10n);

      if (_usernameError == null && _passwordError == null) {
        final emailOrPhone = _usernameController.text;
        final password = _passwordController.text;

        context.read<LoginBloc>().add(
              SubmitLogin(
                username: emailOrPhone,
                password: password,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            title: Text(l10n.translateError(state.error)),
            displayTitle: false,
            description: Text(l10n.translateError(state.error)),
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
                  l10n.loginTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                CustomTextField(
                  controller: _usernameController,
                  hintText: ' ${l10n.usernameLabel}',
                  labelText: l10n.usernameLabel,
                  errorText: _usernameError,
                ),
                PasswordTextField(
                  controller: _passwordController,
                  errorText: _passwordError,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          semanticLabel: l10n.rememberMe,
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
                          l10n.rememberMe,
                          style: OlaTextStyles.primarytext14regular,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.forgotPassword,
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
                    l10n.loginAction,
                    style: OlaTextStyles.primarytext14medium,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.end,
                    l10n.noAccount,
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
                      l10n.registerAction,
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
        l10n.loginAppBarTitle,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      leading: const BackButton(),
    );
  }
}
