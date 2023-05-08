import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late SharedPreferences loginData;

  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>(
      (event, emit) async {
        emit(AuthLoading());
        loginData = await SharedPreferences.getInstance();
        loginData.setString('name', event.name);
        loginData.setBool('isLogin', true);
        final name = loginData.getString('name') ?? '';
        if (name.isEmpty) {
          emit(AuthInitial());
        } else {
          emit(AuthSuccess(name));
        }
      },
    );

    on<AuthCheck>(
      (event, emit) async {
        emit(AuthLoading());
        loginData = await SharedPreferences.getInstance();
        final isLogin = loginData.getBool('isLogin') ?? false;
        final name = loginData.getString('name') ?? '';
        if (isLogin) {
          emit(AuthSuccess(name));
        } else {
          emit(AuthInitial());
        }
      },
    );

    on<AuthLogout>(
      (event, emit) async {
        emit(AuthLoading());
        loginData = await SharedPreferences.getInstance();
        loginData.remove('username');
        loginData.remove('password');
        loginData.remove('isLogin');
        emit(AuthInitial());
      },
    );
  }
}
