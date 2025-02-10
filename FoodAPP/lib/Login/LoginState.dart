part of 'LoginCubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginProcessing extends LoginState{}

class LoginSuccess extends LoginState{}

class LoginFailed extends LoginState{
  String error;

  LoginFailed(this.error);
}

class OTPSend extends LoginState{
  String verificationId;

  OTPSend(this.verificationId);
}

