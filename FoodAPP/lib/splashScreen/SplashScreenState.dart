
abstract class SplashScreenState {}

class SplashInitial extends SplashScreenState {}

class Navigate extends SplashScreenState {
  final bool isLogged;
  Navigate(this.isLogged);
}
