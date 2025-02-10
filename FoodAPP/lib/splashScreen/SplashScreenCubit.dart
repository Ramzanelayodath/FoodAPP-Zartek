import 'package:bloc/bloc.dart';
import '../localStorage/StorageRepository.dart';
import 'SplashScreenState.dart';



class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit(this.storageRepository) : super(SplashInitial());
  final StorageRepository storageRepository;

  Future<void> navigate() async {

    if (state is Navigate) return;

    await Future.delayed(const Duration(seconds: 2));
    bool isLogged = storageRepository.getLoggedIn();
    emit(Navigate(isLogged));
  }


}
