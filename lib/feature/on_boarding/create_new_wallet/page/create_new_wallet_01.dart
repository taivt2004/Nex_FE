import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/cubit/create_wallet_cubit.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/create_wallet_button.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/passphrase_section.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/wallet_name_input.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class CreateNewWallet01Page extends StatefulWidget {
  const CreateNewWallet01Page({super.key});

  @override
  State<CreateNewWallet01Page> createState() => _CreateNewWallet01PageState();
}

class _CreateNewWallet01PageState extends State<CreateNewWallet01Page> {
  final TextEditingController _walletNameController = TextEditingController(
    text: 'Wallet 1',
  );

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CreateWalletCubit()..setWalletName(_walletNameController.text),
      child: Scaffold(
        backgroundColor: OlaColors.appbackground,
        appBar: AppBar(
          backgroundColor: OlaColors.appbackground,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Create new wallet',
            style: PoppinsTextStyles.primary18Regular.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: BlocBuilder<CreateWalletCubit, CreateWalletState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WalletNameInput(
                            controller: _walletNameController,
                            errorText: state.walletNameError,
                            onChanged: (value) {
                              context.read<CreateWalletCubit>().setWalletName(
                                value,
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          PassphraseSection(
                            isSecure: state.isSecure,
                            errorText: state.passphraseError,
                            onChanged: (value) {
                              context
                                  .read<CreateWalletCubit>()
                                  .toggleSecure(isSecure: value);
                            },
                            onPassphraseChanged: (value) {
                              context.read<CreateWalletCubit>().setPassphrase(
                                value,
                              );
                            },
                            onConfirmPassphraseChanged: (value) {
                              context
                                  .read<CreateWalletCubit>()
                                  .setConfirmPassphrase(value);
                            },
                          ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Button nằm ngoài ScrollView, fix position
              BlocBuilder<CreateWalletCubit, CreateWalletState>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                    decoration: BoxDecoration(
                      color: OlaColors.appbackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CreateWalletButton(
                      enabled: state.isFormValid,
                      onPressed: () {
                        final cubit = context.read<CreateWalletCubit>()
                          ..setWalletName(_walletNameController.text);
                        if (cubit.state.walletNameError != null) {
                          return;
                        }
                        context.go(AppRouter.home);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
