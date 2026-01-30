part of 'lock_screen_bloc.dart';

abstract class LockScreenEvent {}

class LockStarted extends LockScreenEvent {}
class PassphraseChanged extends LockScreenEvent {
  PassphraseChanged(this.value);

  final String value;
}

class PassphraseSubmitted extends LockScreenEvent { 
  PassphraseSubmitted(this.value); 

  final String value;
}

class ResetWalletTapped extends LockScreenEvent {}
class ResetWalletConfirmed extends LockScreenEvent {}
