import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'already_have_wallet_event.dart';
part 'already_have_wallet_state.dart';

class AlreadyHaveWalletBloc extends Bloc<AlreadyHaveWalletEvent, AlreadyHaveWalletState> {
  AlreadyHaveWalletBloc() : super(const AlreadyHaveWalletState()) {
    on<WalletNameChanged>(_onWalletNameChanged);
    on<SecretPhraseChanged>(_onSecretPhraseChanged);
    on<SecureToggled>(_onSecureToggled);
    on<PassphraseChanged>(_onPassphraseChanged);
  }

  void _onWalletNameChanged(
    WalletNameChanged event,
    Emitter<AlreadyHaveWalletState> emit,
  ) {
    emit(
      state.copyWith(
        walletName: event.walletName,
        walletNameError: () => event.error,
      ),
    );
  }

  void _onSecretPhraseChanged(
    SecretPhraseChanged event,
    Emitter<AlreadyHaveWalletState> emit,
  ) {
    emit(state.copyWith(secretPhrase: event.secretPhrase));
  }

  void _onSecureToggled(
    SecureToggled event,
    Emitter<AlreadyHaveWalletState> emit,
  ) {
    emit(state.copyWith(isSecure: event.isSecure));
  }

  void _onPassphraseChanged(
    PassphraseChanged event,
    Emitter<AlreadyHaveWalletState> emit,
  ) {
    emit(state.copyWith(passphrase: event.passphrase));
  }
}
