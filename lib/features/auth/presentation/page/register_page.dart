import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/di/injector.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/register_bloc.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/register_event.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/register_state.dart';
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
        final username = _usernameController.text;
        final password = _passwordController.text;

        context.read<RegisterBloc>().add(
              SubmitRegister(username: username, password: password),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          inProgress = true;
        }
        if (state is RegisterFailure) {
          onFinishLoading?.call();
          InfoToast.error(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor,
            title: Text(l10n.translateError(state.error)),
            displayTitle: false,
            description: Text(l10n.translateError(state.error)),
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
                    l10n.registerTitle,
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
                    l10n.createAccountAction,
                    style: OlaTextStyles.primarytext14medium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.termsOfService,
                      style: OlaTextStyles.subtext12regular,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.viewDetails,
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
        l10n.registerAppBarTitle,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      leading: const BackButton(),
    );
  }
}
