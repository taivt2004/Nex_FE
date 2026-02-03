part of 'lock_bloc.dart';

sealed class LockEvent extends Equatable {
  const LockEvent();

  @override
  List<Object?> get props => [];
}

class LockStarted extends LockEvent {}

class PassphraseChanged extends LockEvent {
  const PassphraseChanged(this.passphrase);
  final String passphrase;

  @override
  List<Object?> get props => [passphrase];
}

class ResetWalletConfirmed extends LockEvent {}
